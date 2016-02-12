function ipc_create_unix_domain_socket
{
  logger_tee_function_begin

  logger_tee_notice "Going to create IPC socket."
  ${E_COMMAND_SOCAT} &
  logger_tee_notice "Created IPC socket."

  logger_tee_function_end
}

function ipc_read_from_unix_domain_socket
{
  logger_tee_function_begin

  if [[ `du /tmp/run_time/${E_DIR_RUN_TIME}/language | cut --fields=1` -ne 0 ]]
  then
    E_TMP_STRING=`cat /tmp/run_time/${E_DIR_RUN_TIME}/language`

    case "${E_TMP_STRING}" in
      "${E_LITERAL_ENGLISH}" )
        > /tmp/run_time/${E_DIR_RUN_TIME}/language
        E_LANGUAGE=${E_LITERAL_ENGLISH}
        logger_tee_notice "Switched to English."
        ;;
      "${E_LITERAL_RUSSIAN}" )
        > /tmp/run_time/${E_DIR_RUN_TIME}/language
        E_LANGUAGE=${E_LITERAL_RUSSIAN}
        logger_tee_notice "Switched to Russian."
        ;;
      * )
        > /tmp/run_time/${E_DIR_RUN_TIME}/language
        logger_tee_notice "Error: obtained unknown data from IPC socket."
        ;;
    esac

  fi

  logger_tee_function_end
}

function ipc_remove_unix_domain_socket
{
  logger_tee_function_begin

  rm --force /tmp/run_time/${E_DIR_RUN_TIME}/euphoria_socket
  logger_tee_notice "Removed obsolete IPC socket."

  logger_tee_function_end
}

function ipc_terminate_euphoria
{
  logger_tee_function_begin

  for I in `pgrep --exact --full --uid ${UID} "${E_COMMAND_ARECORD}"`
  do
    kill ${I}
    logger_tee_notice "Sent SIGTERM to arecord process ${I}."
  done

  for I in `pgrep --exact --full --uid ${UID} "${E_COMMAND_ARECORD_PA}"`
  do
    kill ${I}
    logger_tee_notice "Sent SIGTERM to arecord process ${I}."
  done

  kernel_assert arecord is_not_in_top

  for I in `pgrep --exact --full --uid ${UID} "${E_COMMAND_SOCAT}"`
  do
    kill ${I}
    logger_tee_notice "Sent SIGTERM to socat process ${I}."
  done

  kernel_assert socat is_not_in_top
  rm /run/user/${UID}/euphoria
  logger_tee_notice "Removed lock file."

  logger_tee_notice "Going to terminate euphoria."
  exit ${1}

  logger_tee_function_end
}
