function kernel_assert
{
  logger_tee_function_begin

  if [[ ${E_ASSERTS_ENABLED} == ${E_LITERAL_TRUE} ]]
  then

    case "${2}" in
      "is_not_in_top" )
        [[ `pgrep --full --uid ${UID} "${1}"` ]] && kernel_assert_exit "${*}"
        ;;
    esac

  fi

  logger_tee_function_end
}

function kernel_assert_exit
{
  logger_tee_function_begin

  logger_tee_notice "Assert: \"${1}\", \"${2}\"."
  exit ${E_EXIT_STATUS_FAILURE}

  logger_tee_function_end
}

function kernel_handle_interrupt_ctrl_c
{
  logger_tee_function_begin

  logger_tee_notice "Catched Ctrl-c interrupt."
  ipc_terminate_euphoria ${E_EXIT_STATUS_SUCCESS}

  logger_tee_function_end
}
