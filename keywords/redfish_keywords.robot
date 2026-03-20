*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    OperatingSystem
Library    String
Library    JSONLibrary
Variables    ../variables/redfish_variables.py

*** Variables ***
${REDFISH_BASE_URL}    https://172.14.8.101
${REDFISH_USERNAME}    admin
${REDFISH_PASSWORD}    Password@_

*** Keywords ***
Create Redfish Session
    [Documentation]    创建Redfish API会话
    ${auth}=    Create List    ${REDFISH_USERNAME}    ${REDFISH_PASSWORD}
    Create Session    redfish_session    ${REDFISH_BASE_URL}    auth=${auth}    verify=${False}
    Set Global Variable    ${REDFISH_SESSION}    redfish_session

Get Redfish Resource
    [Documentation]    获取Redfish资源
    [Arguments]    ${endpoint}
    ${response}=    GET On Session    redfish_session    ${endpoint}
    RETURN    ${response}

Validate Response Status
    [Documentation]    验证响应状态码
    [Arguments]    ${response}    ${expected_status}=200
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}
    ...    msg=响应状态码应为${expected_status}，实际为${response.status_code}

Validate Response Has Required Fields
    [Documentation]    验证响应包含必需字段
    [Arguments]    ${response}    ${required_fields}
    ${json_data}=    Set Variable    ${response.json()}

    FOR    ${field}    IN    @{required_fields}
        Run Keyword And Continue On Failure
        ...    Dictionary Should Contain Key    ${json_data}    ${field}
        ...    msg=响应缺少字段: ${field}
    END

Validate Status Fields
    [Documentation]    验证Status字段的值
    [Arguments]    ${response}    ${expected_status}
    ${json_data}=    Set Variable    ${response.json()}

    # 检查是否存在Status字段
    Run Keyword And Continue On Failure
    ...    Dictionary Should Contain Key    ${json_data}    Status
    ...    msg=响应缺少Status字段

    ${status}=    Get From Dictionary    ${json_data}    Status

    FOR    ${key}    IN    @{expected_status.keys()}
        Run Keyword And Continue On Failure
        ...    Dictionary Should Contain Key    ${status}    ${key}
        ...    msg=Status字段缺少子字段: ${key}

        ${expected_value}=    Get From Dictionary    ${expected_status}    ${key}
        ${actual_value}=    Get From Dictionary    ${status}    ${key}

        Run Keyword And Continue On Failure
        ...    Should Be Equal As Strings    ${actual_value}    ${expected_value}
        ...    msg=Status.${key}的值应为'${expected_value}'，实际为'${actual_value}'
    END

Validate PCIeDevice Response
    [Documentation]    验证PCIeDevice接口响应
    [Arguments]    ${response}

    # 验证状态码
    Validate Response Status    ${response}

    # 验证必需字段
    Validate Response Has Required Fields    ${response}    ${EXPECTED_FIELDS}

    # 验证Status字段
    Validate Status Fields    ${response}    ${EXPECTED_STATUS}

    # 验证@odata.id匹配端点
    ${json_data}=    Set Variable    ${response.json()}
    ${odata_id}=    Get From Dictionary    ${json_data}    @odata.id
    Should Contain    ${odata_id}    /redfish/v1/Chassis/1/PCIeDevices/11
    ...    msg=@odata.id字段不匹配预期端点

    # 验证@odata.type包含PCIeDevice
    ${odata_type}=    Get From Dictionary    ${json_data}    @odata.type
    Should Contain    ${odata_type}    PCIeDevice
    ...    msg=@odata.type字段不包含PCIeDevice

    Log To Console    所有验证通过！

Log Response Details
    [Documentation]    记录响应详情
    [Arguments]    ${response}
    ${json_data}=    Set Variable    ${response.json()}

    Log To Console    \n=== 响应详情 ===
    Log To Console    状态码: ${response.status_code}
    Log To Console    响应时间: ${response.elapsed.total_seconds()}秒
    Log To Console    数据ID: ${json_data.get('Id', 'N/A')}
    Log To Console    名称: ${json_data.get('Name', 'N/A')}
    Log To Console    状态: ${json_data.get('Status', {}).get('State', 'N/A')}/${json_data.get('Status', {}).get('Health', 'N/A')}
    Log To Console    ================\n

Log All Response Fields
    [Documentation]    记录响应中的所有字段，用于调试
    [Arguments]    ${response}
    ${json_data}=    Set Variable    ${response.json()}

    Log To Console    \n=== 所有响应字段 ===
    ${keys}=    Get Dictionary Keys    ${json_data}
    FOR    ${key}    IN    @{keys}
        ${value}=    Get From Dictionary    ${json_data}    ${key}
        ${value_type}=    Evaluate    type($value).__name__
        Log To Console    ${key}: ${value_type} = ${value}
    END
    Log To Console    ===================\n