setenv TNS_ADMIN        "/usr/lib/oracle/current/client"
setenv ORACLE_HOME      "/usr/lib/oracle/current/client"
setenv EPLAN      "/usr/lib/oracle/current/client/eplan.sql"

if ($?LD_LIBRARY_PATH) then
setenv LD_LIBRARY_PATH  "$ORACLE_HOME/lib:$LD_LIBRARY_PATH"
else
setenv LD_LIBRARY_PATH  "$ORACLE_HOME/lib"
endif

