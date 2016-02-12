# Literals:
E_DIR_RUN_TIME="euphoria-related"
E_LITERAL_ENGLISH="en-us"
E_LITERAL_FALSE="false"
E_LITERAL_MICROPHONE="default_microphone"
E_LITERAL_PA="pulseaudio"
E_LITERAL_RUSSIAN="ru-ru"
E_LITERAL_TRUE="true"

# General variables:
E_ASSERTS_ENABLED=${E_LITERAL_TRUE}
E_CAT_JSONS=${E_LITERAL_TRUE}
E_CAT_MESSAGES=${E_LITERAL_TRUE}
E_COMMAND_ARECORD="arecord --format=S16_LE --max-file-time=4 --quiet --rate=44100 /tmp/run_time/${E_DIR_RUN_TIME}/waveform_audio"
E_COMMAND_ARECORD_PA="arecord --device=hw:0 --format=S16_LE --max-file-time=5 --quiet --rate=44100 /tmp/run_time/${E_DIR_RUN_TIME}/waveform_audio"
E_COMMAND_ITSELF=`ps --format command --no-headers --pid ${$}`
E_COMMAND_SOCAT="socat UNIX-LISTEN:/tmp/run_time/${E_DIR_RUN_TIME}/euphoria_socket,fork OPEN:/tmp/run_time/${E_DIR_RUN_TIME}/language"
E_CURL_EXTRA="--max-time 15 --request POST --silent"
E_DEVICE=${E_LITERAL_PA}
E_DIR_LOGS="euphoria_logs"
E_EXIT_STATUS_FAILURE="1"
E_EXIT_STATUS_SUCCESS="0"
E_HEADER="Content-Type: audio/x-flac; rate=44100;"
E_LANGUAGE=${E_LITERAL_ENGLISH}
E_LOG_ROTATE_LIMIT_OLD="10000"
E_LOG_ROTATE_LIMIT_RECENT="1000"
E_RESPONSE="/tmp/run_time/${E_DIR_RUN_TIME}/recent_response"
E_SOURCE_MICROPHONE=${E_LITERAL_TRUE}
E_USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36"
E_VERSION="0.9"

# Empty variables:
E_C=
E_CURRENT_FILE_FLAC=
E_CURRENT_FILE_WAVEFORM=
E_CURRENT_JSON_LINE=
E_CURRENT_JSON_LINES_COUNT=
E_EXPR_LINES_HEAD=
E_EXPR_LINES_TAIL=
E_EXPR_LINES_TOTAL=
E_L=
E_LOGGER_STARTED=
E_LOG_VIEWER_FLAG=
E_RECENT_HASH=
E_RECENT_HASH_TMP=
E_TMP_EAX=
E_TMP_EBX=
E_TMP_ECX=
E_TMP_EDX=
E_TMP_EEX=
E_TMP_EFX=
E_TMP_EGX=
E_TMP_STRING=
E_URL=
