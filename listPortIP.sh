#!/bin/bash

# Variable for getting current path
SCRIPT_LOC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# Varible for search all properties file
SEARCH_PROPS=`find $SCRIPT_LOC -name '*.properties'`

# Looping every file properties found
for prop in $SEARCH_PROPS
do
  # Get value from properties and turn into variable
  server_name=`grep "server_name=" $prop | cut -d '=' -f2 | sed "s/,/ /g"`
  OHS_LOC=`grep "domain_loc=" $prop | cut -d '=' -f2`

  for comp in $server_name
  do

        ip_ohs=`grep -i 'Listen' "${OHS_LOC}"/config/fmwconfig/components/OHS/"${comp}"/httpd.conf | \
                grep -v '#' | \
                awk '{print $2}'`

        ip_ssl=`grep -i 'Listen' "${OHS_LOC}"/config/fmwconfig/components/OHS/"${comp}"/ssl.conf | \
                grep -v '#' | \
                awk '{print $2}'`

        target=`grep -i 'WebLogicCluster' "${OHS_LOC}"/config/fmwconfig/components/OHS/"${comp}"/mod_wl_ohs.conf | \
                grep -v '#' | \
                awk '{print $2}' | \
                sed "s/,/ /g"`

        curl -q http://$ip_ohs &> /dev/null

        retVal=$?
        if  [ $retVal -eq 0 ]
            then state=`echo RUNNING`
        else
            state=`echo FAILED`
        fi

        echo "Instance : " $comp
        echo "State    : " $state
        echo "  - Proxy Host    : " $ip_ohs
        echo "  - Proxy SSL     : " $ip_ssl
        echo "  - Target List   :"

        for tar in $target
        do
            curl -q http://$tar &> /dev/null
            retVal=$?

                if  [ $retVal -eq 0 ]
                    then stat=`echo OK`
                else
                    stat=`echo FAILED`
                fi

            echo "      - " $tar  $stat
        done

        echo

  done

done
