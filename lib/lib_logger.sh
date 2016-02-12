function logger_cat_json
{
  if [[ ${1} == "^NULL_JSON$" ]]
  then
    echo "`tput setaf 1`JSON is empty!`tput sgr0`"
  else
    [[ ${1} == "^NULL_JSON_LINE$" ]] && echo "`tput setaf 1`JSON line is empty!`tput sgr0`" || echo "`tput setaf 1`${*}`tput sgr0`"
  fi
}

function logger_cat_message
{
  echo "${*}"
}

function logger_cat_notice
{
  echo "`tput setaf 2`${*}`tput sgr0`"
}

function logger_log_json
{
  if [[ ${1} == "^NULL_JSON$" ]]
  then
    logger_log_message "JSON is empty!"
  else
    [[ ${1} == "^NULL_JSON_LINE$" ]] && logger_log_message "JSON line is empty!" || logger_log_message "${*}"
  fi
}

function logger_log_message
{
  echo "`date '+%H:%M:%S'` ${*}" >> /tmp/run_time/${E_DIR_RUN_TIME}/applicaion_log
}

function logger_log_speech
{
  echo "${*}" >> ~/${E_DIR_LOGS}/recent_log
}

function logger_rotate_old_log
{
  E_EXPR_LINES_TAIL=${E_LOG_ROTATE_LIMIT_OLD}
  E_EXPR_LINES_TOTAL=`cat ~/${E_DIR_LOGS}/old_log | wc --lines`

  if [[ ${E_EXPR_LINES_TAIL} -lt ${E_EXPR_LINES_TOTAL} ]]
  then
    tail --lines=${E_EXPR_LINES_TAIL} ~/${E_DIR_LOGS}/old_log > /tmp/run_time/${E_DIR_RUN_TIME}/old_log_tail
    mv /tmp/run_time/${E_DIR_RUN_TIME}/old_log_tail ~/${E_DIR_LOGS}/old_log
    logger_tee_notice "Rotated old log."
  fi
}

function logger_rotate_recent_log
{
  E_EXPR_LINES_TAIL=${E_LOG_ROTATE_LIMIT_RECENT}
  E_EXPR_LINES_TOTAL=`cat ~/${E_DIR_LOGS}/recent_log | wc --lines`

  if [[ ${E_EXPR_LINES_TAIL} -lt ${E_EXPR_LINES_TOTAL} ]]
  then
    E_EXPR_LINES_HEAD=$((${E_EXPR_LINES_TOTAL}-${E_EXPR_LINES_TAIL}))
    head --lines=${E_EXPR_LINES_HEAD} ~/${E_DIR_LOGS}/recent_log >> ~/${E_DIR_LOGS}/old_log
    tail --lines=${E_EXPR_LINES_TAIL} ~/${E_DIR_LOGS}/recent_log > /tmp/run_time/${E_DIR_RUN_TIME}/recent_log_tail
    mv /tmp/run_time/${E_DIR_RUN_TIME}/recent_log_tail ~/${E_DIR_LOGS}/recent_log
    logger_tee_notice "Rotated recent log."
  fi
}

function logger_tee_function_begin
{
  logger_tee_message "--> ${FUNCNAME[1]}"
}

function logger_tee_function_end
{
  logger_tee_message "<-- ${FUNCNAME[1]}"
}

function logger_tee_json
{
  [[ ${E_LOGGER_STARTED} == ${E_LITERAL_TRUE} ]] && logger_log_json "${*}"
  [[ ${E_CAT_JSONS} == ${E_LITERAL_TRUE} ]] && logger_cat_json "${*}"
}

function logger_tee_message
{
  [[ ${E_LOGGER_STARTED} == ${E_LITERAL_TRUE} ]] && logger_log_message "${*}"
  [[ ${E_CAT_MESSAGES} == ${E_LITERAL_TRUE} ]] && logger_cat_message "${*}"
}

function logger_tee_notice
{
  [[ ${E_LOGGER_STARTED} == ${E_LITERAL_TRUE} ]] && logger_log_message "${*}"
  [[ ${E_CAT_MESSAGES} == ${E_LITERAL_TRUE} ]] && logger_cat_notice "${*}"
}
