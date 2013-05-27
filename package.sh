#!/bin/bash
## Sourcefabric
## Newscoop Packaging Script
## Yorick Terweijden

# Defines the Git URL
REPO='https://github.com/sourcefabric/Newscoop.git'

# Set some defaults
FORMAT='zip'
METHOD=''
DEFAULT_COMMIT='master'
COMMIT=''

TARGET_DIR='newscoop_packaging'

exit_usage() {
    echo -e "------------------------------------------------------------"
    echo -e "Sourcefabric Newscoop Packaging script"
    echo -e "Usage"
    echo -e "------------------------------------------------------------"
    echo -e "   -h shows this usage"
    echo -e "   -f FORMAT"
    echo -e "      The output format, can be either ZIP or TAR"
    echo -e "      Defaults to ZIP"
    echo -e "   -d TARGET_DIR"
    echo -e "      The Git clone TARGET_DIR"
    echo -e "      Defaults to newscoop_packaging"
    echo -e "------------------------------------------------------------"
    echo -e "Git checkout method"
    echo -e "Only one of the following can be used."
    echo -e "------------------------------------------------------------"
    echo -e "   -c GIT_COMMIT"
    echo -e "      Defines which GIT COMMIT HASH should be packaged"
    echo -e "      GIT COMMIT HASH needs to be a minimum of 7 characters"
    echo -e "   -b GIT_BRANCH"
    echo -e "      Defines which GIT BRANCH should be packaged"
    echo -e "   -t GIT_TAG"
    echo -e "      Defines which GIT TAG should be packaged"
    echo -e ""
    echo -e "If none is specified it defaults to BRANCH [master]"
    exit 1
}

# Loop through all the options and set the vars
while getopts ":hc:b:f:t:d:" opt; do
    case $opt in
        h)
            exit_usage
            ;;
        f)
            # Check if FORMAT is either ZIP or TAR
            case ${OPTARG,,} in
                zip)
                    FORMAT='ZIP'
                    ;;
                tar)
                    FORMAT='TAR'
                    ;;
                *)
                    echo "Format $OPTARG unknown" >&2
                    exit_usage
                    ;;
            esac
            echo "Format $FORMAT selected." >&2
            ;;
        c)
            # Check if COMMIT is 7 chars minimum
            if [ -z "$COMMIT" ]; then
                if [ ${#OPTARG} -ge 7 ]; then
                    COMMIT=$OPTARG
                    METHOD='HASH'
                else
                    echo "Error, GIT COMMIT HASH needs to be at least 7 characters: $OPTARG" >&2
                    exit_usage
                fi
            else
                echo -e "Only one method for Git checkout can be specified!"
                echo -e ""
                exit_usage
            fi
            ;;
        b)
            if [ -z "$COMMIT" ]; then
                COMMIT=$OPTARG
                METHOD='BRANCH'
            else
                echo -e "Only one method for Git checkout can be specified!"
                echo -e ""
                exit_usage
            fi
            ;;
        t)
            if [ -z "$COMMIT" ]; then
                COMMIT=$OPTARG
                METHOD='TAG'
            else
                echo -e "Only one method for Git checkout can be specified!"
                echo -e ""
                exit_usage
            fi
            ;;
        d)
            TARGET_DIR=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit_usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            echo -e ""
            exit_usage
            ;;
    esac
done

if [ -z $COMMIT ]; then
    COMMIT=$DEFAULT_COMMIT
    METHOD="BRANCH"
fi

TARGET_DIR_GIT=$TARGET_DIR
TARGET_DIR_GIT+='/.git'

# Clone the Git repo
if [ ! -d $TARGET_DIR ]; then
    echo "Git $METHOD specified: $COMMIT"
    git clone $REPO $TARGET_DIR
else
    if [ -d $TARGET_DIR_GIT ]; then
        echo "Git $METHOD specified: $COMMIT"
        echo "Git repo already cloned... checking"
        pushd $TARGET_DIR 1> /dev/null
        git pull origin
        popd 1> /dev/null
    else
        echo "Directory $TARGET_DIR exists, please remove or specify a different one with:"
        echo -e "   -d TARGET_DIR"
        echo -e ""
        exit_usage
    fi
fi

# Checkout the Git repo
pushd $TARGET_DIR 1> /dev/null
git checkout $COMMIT
if [ $? = 0 ]; then
    echo "Git checkout succeeded"
else
    echo "Git checkout failed"
    exit
fi