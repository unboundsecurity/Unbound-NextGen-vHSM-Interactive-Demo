from kmip.core import attributes as attr
from kmip.core import enums
from kmip.core import objects as obj

from kmip.core.objects import Attribute
from kmip.core.attributes import Name
from kmip.core.enums import NameType

from kmip.core.factories import attributes
from kmip.pie import factory
from kmip.pie import objects

from kmip.services.kmip_client import KMIPProxy
import logging

logging.basicConfig()

#Note : cert is the external entry point, key is the client key signed by the root ca, ca is the root ca

# Open client
client = KMIPProxy(host='ukc-ep',port=5696,certfile='/certs/kmip-client.crt',keyfile='/certs/kmip-client.key',ca_certs='/certs/ukc_root_ca.pem')

client.open()
	
# Locate
result = client.locate()                           
status = result.result_status.value
if status == enums.ResultStatus.SUCCESS:
    print("Locate succeeded , UIDS : ")
    for uuid in result.uuids:
        print("  " + uuid)
else:
    reason = result.result_reason.value
    message = result.result_message.value
    raise exceptions.KmipOperationFailure(status, reason, message)

client.close()
