*** Settings ***
Documentation    Redfish API测试 - PCIeDevice接口
Resource    ../resources/redfish_resources.robot
Library    RequestsLibrary
Library    Collections
Library    String
Library    JSONLibrary

Suite Setup    初始化测试环境
Suite Teardown    清理测试环境

*** Variables ***
${PCIEDEVICE_ENDPOINT}    /redfish/v1/Chassis/1/PCIeDevices/11

*** Test Cases ***
验证PCIeDevice接口可访问性
    [Documentation]    验证PCIeDevice接口可以正常访问并返回200状态码
    [Tags]    smoke    pcie    api

    当用户请求PCIeDevice接口
    那么接口应返回200状态码

验证PCIeDevice接口响应结构
    [Documentation]    验证PCIeDevice接口返回的数据结构符合预期
    [Tags]    functional    pcie    api

    当用户请求PCIeDevice接口
    那么响应应包含所有必需字段
    并且Status字段应显示正确状态

验证PCIeDevice接口数据完整性
    [Documentation]    验证PCIeDevice接口返回的数据完整性
    [Tags]    functional    pcie    api

    当用户请求PCIeDevice接口
    那么@odata.id字段应匹配端点
    并且@odata.type字段应包含PCIeDevice

*** Keywords ***
初始化测试环境
    [Documentation]    测试套件初始化
    Log To Console    开始执行PCIeDevice接口测试...
    Create Redfish Session
    Set Suite Variable    ${EXPECTED_FIELDS}    ${EXPECTED_FIELDS}
    Set Suite Variable    ${EXPECTED_STATUS}    ${EXPECTED_STATUS}

清理测试环境
    [Documentation]    测试套件清理
    Delete All Sessions
    Log To Console    PCIeDevice接口测试执行完成！

当用户请求PCIeDevice接口
    ${response}=    Get Redfish Resource    ${PCIEDEVICE_ENDPOINT}
    Set Test Variable    ${RESPONSE}    ${response}
    Log Response Details    ${response}

那么接口应返回200状态码
    Validate Response Status    ${RESPONSE}    200

那么响应应包含所有必需字段
    Validate Response Has Required Fields    ${RESPONSE}    ${EXPECTED_FIELDS}

并且Status字段应显示正确状态
    Validate Status Fields    ${RESPONSE}    ${EXPECTED_STATUS}

那么@odata.id字段应匹配端点
    ${json_data}=    Set Variable    ${RESPONSE.json()}
    ${odata_id}=    Get From Dictionary    ${json_data}    @odata.id
    Should Contain    ${odata_id}    /redfish/v1/Chassis/1/PCIeDevices/11
    ...    msg=@odata.id字段不匹配预期端点

并且@odata.type字段应包含PCIeDevice
    ${json_data}=    Set Variable    ${RESPONSE.json()}
    ${odata_type}=    Get From Dictionary    ${json_data}    @odata.type
    Should Contain    ${odata_type}    PCIeDevice
    ...    msg=@odata.type字段不包含PCIeDevice