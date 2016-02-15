function k_main_euphoria_killer
{
  for I in `pgrep --full --uid ${UID} "/tmp/run_time/euphoria-related/"`
  do
    [[ ${$} -eq ${I} ]] || kill ${I}
  done

  for I in `pgrep --full --uid ${UID} "sh ./euphoria"`
  do
    [[ ${$} -eq ${I} ]] || kill ${I}
  done
}
