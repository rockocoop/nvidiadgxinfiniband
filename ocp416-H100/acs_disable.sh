#!/bin/bash
# Disable ACS on every device that supports it

# Don't do anything on DGX-2 platforms, they are fine the way they are.
PLATFORM=$(dmidecode --string system-product-name)
echo "PLATFORM=${PLATFORM}"

# Enforce platform check here.
case "${PLATFORM}" in
    "NVIDIA DGX-2"*)
        echo "INFO: Disabling ACS is no longer necessary for ${PLATFORM}"
        exit  0
        ;;
    *)
        ;;
esac

# must be root to access extended PCI config space
if [ "$EUID" -ne 0 ]; then
  echo "ERROR: $0 must be run as root"
  exit 1
fi

for BDF in `lspci -d "*:*:*" | awk '{print $1}'`; do

    # skip if it doesn't support ACS
    setpci -v -s ${BDF} ECAP_ACS+0x6.w > /dev/null 2>&1
    if [ $? -ne 0 ]; then
            #echo "${BDF} does not support ACS, skipping"
            continue
    fi

    echo "Disabling ACS on `lspci -s ${BDF}`"
    setpci -v -s ${BDF} ECAP_ACS+0x6.w=0000
    if [ $? -ne 0 ]; then
        echo "Error disabling ACS on ${BDF}"
            continue
    fi
    NEW_VAL=`setpci -v -s ${BDF} ECAP_ACS+0x6.w | awk '{print $NF}'`
    if [ "${NEW_VAL}" != "0000" ]; then
        echo "Failed to disable ACS on ${BDF}"
            continue
    fi
done
exit 0
