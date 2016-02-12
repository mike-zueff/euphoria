function e_check_lock_file
{
  logger_tee_function_begin

  if [[ -f /run/user/${UID}/euphoria ]]
  then

    if [[ `pgrep --count --full --uid ${UID} "${E_COMMAND_ITSELF}"` -eq 1 ]]
    then
      logger_tee_notice "Lock file exists while no euphoria is running. Going to reset IPC manager and exit."
      ipc_terminate_euphoria ${E_EXIT_STATUS_FAILURE}
    else
      logger_tee_notice "Another instance is running. Going to terminate current instance."
      exit ${E_EXIT_STATUS_FAILURE}
    fi

  else
    touch /run/user/${UID}/euphoria
    logger_tee_notice "Created lock file."
  fi

  logger_tee_function_end
}

function e_do_monitor_ctrl_c
{
  logger_tee_function_begin

  trap kernel_handle_interrupt_ctrl_c INT

  logger_tee_function_end
}

function e_do_monitor_exit_statuses
{
  logger_tee_function_begin

  set -e

  logger_tee_function_end
}

function e_invoke_alsa_recorder
{
  logger_tee_function_begin

  if [[ ${1} == "-m" ]]
  then
    ${E_COMMAND_ARECORD} &
    E_DEVICE=${E_LITERAL_MICROPHONE}
    logger_tee_notice "Invoked ALSA recorder (microphone)."
  else
    ${E_COMMAND_ARECORD_PA} &
    logger_tee_notice "Invoked ALSA recorder (PulseAudio)."
  fi

  logger_tee_function_end
}

function e_main_euphoria
{
  logger_tee_function_begin

  if [[ ${E_DEVICE} == ${E_LITERAL_MICROPHONE} ]]
  then
    logger_tee_notice "Selected microphone as the active device."
  else
    logger_tee_notice "Selected PulseAudio as the active device."
  fi

  logger_tee_notice "Entered main infinite loop."

  until false
  do
    logger_tee_message "Started loop iteration."
    ipc_read_from_unix_domain_socket
    E_URL="https://www.google.com/speech-api/v2/recognize?client=chromium&key=${E_KEY}&lang=${E_LANGUAGE}&output=json"

    if [[ `ls /tmp/run_time/${E_DIR_RUN_TIME}/waveform_audio-* 2>/dev/null | wc --lines` -gt 1 ]]
    then
      E_CURRENT_FILE_WAVEFORM=`ls -v /tmp/run_time/${E_DIR_RUN_TIME}/waveform_audio-* | head --lines=1`
      E_CURRENT_FILE_FLAC=`echo ${E_CURRENT_FILE_WAVEFORM} | sed "s/\/waveform_audio-/\/flac-/"`
      logger_tee_notice "Detected waveform file ${E_CURRENT_FILE_WAVEFORM}."
      flac --best --delete-input-file --output-name=${E_CURRENT_FILE_FLAC} --silent ${E_CURRENT_FILE_WAVEFORM}
      logger_tee_notice "Generated FLAC file ${E_CURRENT_FILE_FLAC}, removed waveform one."
      > ${E_RESPONSE}
      curl --data-binary @${E_CURRENT_FILE_FLAC} --header "${E_HEADER}" --output ${E_RESPONSE} --user-agent "${E_USER_AGENT}" ${E_CURL_EXTRA} ${E_URL}
      logger_tee_notice "Posted FLAC file ${E_CURRENT_FILE_FLAC}."

      if [[ `du ${E_RESPONSE} | cut --fields=1` -eq 0 ]]
      then
        logger_log_speech "^BREAK$"
        logger_tee_json "^NULL_JSON$"
      else
        json_parse_and_validate
      fi

      rm ${E_CURRENT_FILE_FLAC}
      logger_tee_notice "Removed FLAC file ${E_CURRENT_FILE_FLAC}."
      logger_rotate_recent_log
      logger_rotate_old_log
    fi

    logger_tee_message "Finished loop iteration."
    sleep .5
  done

  logger_tee_function_end
}

function e_show_startup_notification
{
  logger_tee_function_begin

  logger_tee_notice "euphoria version ${E_VERSION} started."

  logger_tee_function_end
}

function e_touch_logs_directory
{
  logger_tee_function_begin

  if [[ ! -d ~/${E_DIR_LOGS} ]]
  then
    mkdir ~/${E_DIR_LOGS}
    logger_tee_notice "Created new directory for logs."
  fi

  if [[ ! -f ~/${E_DIR_LOGS}/old_log ]]
  then
    touch ~/${E_DIR_LOGS}/old_log
    logger_tee_notice "Created empty old log file."
  fi

  if [[ ! -f ~/${E_DIR_LOGS}/recent_log ]]
  then
    touch ~/${E_DIR_LOGS}/recent_log
    logger_tee_notice "Created empty recent log file."
  fi

  logger_log_speech "^NEW_INVOKATION$"

  logger_tee_function_end
}

function e_touch_run_time_directory
{
  logger_tee_function_begin

  if [[ -d /tmp/run_time ]]
  then

    if [[ ! -d /tmp/run_time/${E_DIR_RUN_TIME} ]]
    then
      mkdir /tmp/run_time/${E_DIR_RUN_TIME}
      logger_tee_notice "Created new euphoria-related directory."
    fi

  else
    mkdir --parents /tmp/run_time/${E_DIR_RUN_TIME}
    logger_tee_notice "Created new run time and euphoria-related directories."
  fi

  if [[ -f /tmp/run_time/${E_DIR_RUN_TIME}/applicaion_log ]]
  then
    E_LOGGER_STARTED=${E_LITERAL_TRUE}
  else
    touch /tmp/run_time/${E_DIR_RUN_TIME}/applicaion_log
    E_LOGGER_STARTED=${E_LITERAL_TRUE}
    logger_tee_notice "Created application log file."
  fi

  > /tmp/run_time/${E_DIR_RUN_TIME}/language
  ipc_remove_unix_domain_socket
  ipc_create_unix_domain_socket
  logger_tee_notice "Going to remove old waveform audio files."
  [[ `ls /tmp/run_time/${E_DIR_RUN_TIME}/waveform_audio* 2>/dev/null | wc --lines` -eq 0 ]] || rm /tmp/run_time/${E_DIR_RUN_TIME}/waveform_audio*
  logger_tee_notice "Going to remove old FLAC audio files."
  [[ `ls /tmp/run_time/${E_DIR_RUN_TIME}/flac-* 2>/dev/null | wc --lines` -eq 0 ]] || rm /tmp/run_time/${E_DIR_RUN_TIME}/flac-*

  logger_tee_function_end
}
