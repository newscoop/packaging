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

exit_usage() {
    echo "Usage:"
    echo -e "   -h shows this usage"
    echo -e "   -f FORMAT"
    echo -e "      The output format, can be either ZIP or TAR"
    echo -e "      Defaults to ZIP"
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
    exit 1
}

# Loop through all the options and set the vars
while getopts ":hc:b:f:t:" opt; do
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

if [ -z "$COMMIT" ]; then
    COMMIT=$DEFAULT_COMMIT
    METHOD="BRANCH"
fi

echo "Git $METHOD specified: $COMMIT"