function c_calculate_hash
{
  E_RECENT_HASH_TMP=`md5sum ~/${E_DIR_LOGS}/recent_log`

  if [[ ${E_RECENT_HASH} != ${E_RECENT_HASH_TMP} ]]
  then
    E_LOG_VIEWER_FLAG=${E_LITERAL_TRUE}
    E_RECENT_HASH=${E_RECENT_HASH_TMP}
  fi
}

function c_centralize
{
  E_TMP_EAX=$((`tput cols`-${#E_TMP_EEX}))
  E_TMP_EBX=$((${E_TMP_EAX}%2))
  E_TMP_ECX=$((${E_TMP_EAX}-${E_TMP_EBX}))
  E_TMP_EDX=$((${E_TMP_ECX}/2))
  c_generate_line "+" $((${E_TMP_EBX}+${E_TMP_EDX}))
  echo -n "`tput setaf 2`${E_TMP_STRING}${E_TMP_EEX}"
  c_generate_line "+" ${E_TMP_EDX}
  echo -n "${E_TMP_STRING}`tput sgr0`"

  if [[ ${1} == ${E_LITERAL_TRUE} ]]
  then
    echo
  fi
}

function c_check_terminal_size
{
  if [[ `tput cols` -lt 64 || `tput lines` -lt 16 ]]
  then
    exit ${E_EXIT_STATUS_FAILURE}
  else

    if [[ `tput cols` -ne ${E_C} ]]
    then
      E_C=`tput cols`
      E_LOG_VIEWER_FLAG=${E_LITERAL_TRUE}
    fi

    if [[ `tput lines` -ne ${E_L} ]]
    then
      E_L=`tput lines`
      E_LOG_VIEWER_FLAG=${E_LITERAL_TRUE}
    fi

  fi
}

function c_disable_stdin
{
  stty -echo
}

function c_do_monitor_exit_statuses
{
  set -e
}

function c_generate_line
{
  E_TMP_STRING=""

  for I in `seq 1 ${2}`
  do
    E_TMP_STRING="${E_TMP_STRING}${1}"
  done
}

function c_ipc_send_language_value
{
  E_LOG_VIEWER_FLAG=${E_LITERAL_TRUE}
  [[ ${1} == "-r" ]] && E_LANGUAGE=${E_LITERAL_RUSSIAN} || E_LANGUAGE=${E_LITERAL_ENGLISH}
  set +e
  echo ${E_LANGUAGE} | socat UNIX-CLIENT:/tmp/run_time/${E_DIR_RUN_TIME}/euphoria_socket STDIN 2>/dev/null
  set -e
}

function c_main_euphoria_log_viewer
{
  until false
  do
    c_calculate_hash
    c_check_terminal_size

    if [[ ${E_LOG_VIEWER_FLAG} == ${E_LITERAL_TRUE} ]]
    then
      clear
      E_TMP_EEX=" euphoria log viewer ${E_VERSION} "
      c_centralize ${E_LITERAL_TRUE}
      awk --file awk/silence_processor ~/${E_DIR_LOGS}/recent_log > /tmp/run_time/${E_DIR_RUN_TIME}/processed_log
      awk --file awk/restarts_processor /tmp/run_time/${E_DIR_RUN_TIME}/processed_log > /tmp/run_time/${E_DIR_RUN_TIME}/processed_log_restarts
      mv --force /tmp/run_time/${E_DIR_RUN_TIME}/processed_log_restarts /tmp/run_time/${E_DIR_RUN_TIME}/processed_log
      fold --width=${E_C} /tmp/run_time/${E_DIR_RUN_TIME}/processed_log > /tmp/run_time/${E_DIR_RUN_TIME}/processed_log_fold
      mv --force /tmp/run_time/${E_DIR_RUN_TIME}/processed_log_fold /tmp/run_time/${E_DIR_RUN_TIME}/processed_log
      E_TMP_EAX=`cat /tmp/run_time/${E_DIR_RUN_TIME}/processed_log | wc --lines`
      E_TMP_EGX=$((${E_L}-2))

      if [[ ${E_TMP_EAX} -gt ${E_TMP_EGX} ]]
      then
        tail --lines=${E_TMP_EGX} /tmp/run_time/${E_DIR_RUN_TIME}/processed_log > /tmp/run_time/${E_DIR_RUN_TIME}/processed_log_tail
        mv --force /tmp/run_time/${E_DIR_RUN_TIME}/processed_log_tail /tmp/run_time/${E_DIR_RUN_TIME}/processed_log
      fi

      if [[ ${E_TMP_EAX} -lt ${E_TMP_EGX} ]]
      then
        E_TMP_ECX=$((${E_TMP_EGX}-${E_TMP_EAX}))

        for I in `seq 1 ${E_TMP_ECX}`
        do
          sed -in-place '1s/^/\n/' /tmp/run_time/${E_DIR_RUN_TIME}/processed_log
        done

      fi

      for I in `seq 1 ${E_TMP_EGX}`
      do
        E_TMP_EFX=`sed "${I}q;d" /tmp/run_time/${E_DIR_RUN_TIME}/processed_log`

        case "${E_TMP_EFX}" in
          "^BREAK$" )
            echo
            ;;
          "^NEW_INVOKATION$" )
            c_generate_line "+" ${E_C}
            echo -n "`tput setaf 5`${E_TMP_STRING}`tput sgr0`"
            [[ ${E_TMP_EGX} -ne ${I} ]] && echo
            ;;
          * )
            echo "${E_TMP_EFX}"
            ;;
        esac

      done

      [[ ${E_LANGUAGE} == ${E_LITERAL_RUSSIAN} ]] && E_TMP_EEX=" active language: russian " || E_TMP_EEX=" active language: english "
      c_centralize ${E_LITERAL_FALSE}
      E_LOG_VIEWER_FLAG=${E_LITERAL_FALSE}
    fi

    sleep .5
  done
}

function c_touch_flag
{
  E_LOG_VIEWER_FLAG=${E_LITERAL_TRUE}
  E_RECENT_HASH=`md5sum ~/${E_DIR_LOGS}/recent_log`
}
