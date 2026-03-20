"""
Redfish API测试变量配置
"""
REDFISH_BASE_URL = "https://172.14.8.101"
REDFISH_USERNAME = "admin"
REDFISH_PASSWORD = "Password@_"

# API端点
CHASSIS_PCIEDEVICE_ENDPOINT = "/redfish/v1/Chassis/1/PCIeDevices/11"

# 预期响应字段
EXPECTED_FIELDS = [
    "@odata.id",
    "@odata.type",
    "Id",
    "Name",
    "Description",
    "Status",
    "FirmwareVersion",
    "Manufacturer",
    "Model",
    "SerialNumber",
    "PartNumber"
]

# 预期状态值
EXPECTED_STATUS = {
    "State": "Enabled",
    "Health": "OK"
}