function json_parse_and_validate
{
  logger_tee_function_begin

  E_CURRENT_JSON_LINES_COUNT=`cat ${E_RESPONSE} | wc --lines`

  for I in `seq 1 ${E_CURRENT_JSON_LINES_COUNT}`
  do
    E_CURRENT_JSON_LINE=`sed "${I}q;d" ${E_RESPONSE}`

    case "${I}" in
      "1" )
        [[ ${E_CURRENT_JSON_LINES_COUNT} -eq 1 ]] && logger_log_speech "^BREAK$"
        [[ ${E_CURRENT_JSON_LINE} == "" ]] && logger_tee_json "^NULL_JSON_LINE$" || logger_tee_json "${E_CURRENT_JSON_LINE}"
        ;;
      "2" )

        if [[ ${E_CURRENT_JSON_LINE} == "" ]]
        then
          logger_log_speech "^BREAK$"
          logger_tee_json "^NULL_JSON_LINE$"
        else
          logger_log_speech `echo "${E_CURRENT_JSON_LINE}" | sed 's/^{"result":\[{"alternative":\[{"transcript":"\([^"]\+\).\+$/\1/'`
          logger_tee_json "${E_CURRENT_JSON_LINE}"
        fi

        ;;
      * )
        [[ ${E_CURRENT_JSON_LINE} == "" ]] && logger_tee_json "^NULL_JSON_LINE$" || logger_tee_json "${E_CURRENT_JSON_LINE}"
        ;;
    esac

  done

  logger_tee_function_end
}
