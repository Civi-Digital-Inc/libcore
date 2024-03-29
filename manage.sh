#!/usr/bin/env sh

OK='[\033[1;32mOK\033[0m]\t'
WARN='[\033[1;33mWARN\033[0m]\t'
ERROR='[\033[1;31mERROR\033[0m]\t'
USAGE='Usage: ./manage.zsh [usage/docs/dev/test]'
RUNNING='\033[1;33m __  ___ __  __  ______  ______  __  ______  ______
/\ \/ ___\ \/\ \/\  __ \/\  __ \/\ \/\  __ \/\  __ \\
\ \  /___/\ \_\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \_\ \\
 \ \_\   \ \_____\ \_\ \ \ \_\ \ \ \_\ \_\ \_\ \___  \\
  \/_/    \/_____/\/_/\/_/\/_/\/_/\/_/\/_/\/_/\/___/\ \\
 __________________________________________________\_\ \\
/\______________________________________________________\\
\/______________________________________________________/\033[0m'

TESTING='\033[1;33m  ___                        ___
 /\  \                      /\  \
 \_\  \___                  \_\  \___
/\___   __\  ______    ____/\___   __\  __  ______  ______
\/_/ \  \_/ /\  __ \  /  __\/_/ \  \_/ /\ \/\  __ \/\  __ \
    \ \  \__\ \ \_\_\/\__,  \  \ \  \__\ \ \ \ \ \ \ \ \_\ \
     \ \_____\ \_____\/\____/   \ \_____\ \_\ \_\ \_\ \___  \
      \/_____/\/_____/\/___/     \/_____/\/_/\/_/\/_/\/___/\ \
 _________________________________________________________\_\ \
/\_____________________________________________________________\
\/_____________________________________________________________/\033[0m\t'

assert() {
    exit_code=$?
    [ $exit_code = 0 ] && ([ -z $1 ] || echo $OK$1) || (
    [ -z $2 ] || echo $ERROR$2 - exit code:$exit_code)
}

case ${1:-'usage'} in
    dev)
        echo $RUNNING
        exec pdoc -n civi_core \
            --logo "" \
            --logo-link "" \
            --favicon ""
        assert "Server ran successfully" "Server exited with an error" ;;
    docs)
        echo "$WARN Generating Docs"
        pdoc civi_core -o docs \
            --logo "https://civi-core.gaytomycode.com/assets/logo.jpg" \
            --logo-link "https://civi.gaytomycode.com" \
            --favicon "https://civi.gaytomycode.com/favicon.ico"
        assert "Generated successfully" "Generation Failed" ;;
    test)
        echo $TESTING
        echo "$WARN Code Quality Check"
        echo "$WARN Linting source codebase"
        blue civi_core
        assert "Linted successfully" "Failed to lint"
        echo "$WARN Sorting imports"
        isort civi_core
        assert "Sorted" "Failed to sort"
        echo "$WARN Running Flake8"
        flake8 civi_core
        assert "Clean code noice" "Go clean your code"
        echo "$WARN Running mypy"
        mypy civi_core
        assert "Static!!" "Go fix ur code dude"

        ;;
        # NOTE(gaytomycode): Should unit test this core because all
        #   microservices depend on it
        # echo "$WARN Running tests"
        # pytest --cov --cov-report html
        # assert "Tested successfully" "Testing Failed" ;;
    usage)
        echo $WARN$USAGE ;;
    *)
        echo $ERROR$USAGE ;;
esac
