*** Settings ***
Documentation    Redfish API测试主套件
Library    Process
Library    OperatingSystem

*** Variables ***
${ROBOT_COMMAND}    robot
${SUBTESTS_DIR}    subtests

*** Test Cases ***
运行所有PCIeDevice测试
    [Documentation]    执行所有PCIeDevice相关测试
    [Tags]    run-all-tests
    运行测试目录    所有PCIeDevice测试

*** Keywords ***
运行测试目录
    [Documentation]    运行指定目录下的所有测试
    [Arguments]    ${test_suite_name}=所有测试
    Log To Console    开始执行${test_suite_name}...

    # 创建报告目录（如果不存在）
    Create Directory    ${OUTPUTDIR}
    ${subtests_dir}=    Join Path    ${OUTPUTDIR}    ${SUBTESTS_DIR}
    Create Directory    ${subtests_dir}

    # 运行当前目录下的所有测试（排除run-all-tests标签的测试）
    ${result}=    Run Process    ${ROBOT_COMMAND}    --outputdir    ${subtests_dir}    --name    ${test_suite_name}    --exclude    run-all-tests    .
    ...    stdout=${subtests_dir}/stdout.log    stderr=${subtests_dir}/stderr.log

    # 记录执行结果
    Log To Console    测试执行完成！
    Log To Console    退出码: ${result.rc}
    Log To Console    标准输出: ${result.stdout}
    Log To Console    标准错误: ${result.stderr}

    # 检查执行结果，但不因测试失败而失败
    Run Keyword If    ${result.rc} != 0
    ...    Log To Console    警告：测试执行有失败，退出码: ${result.rc}
    Run Keyword If    ${result.rc} == 0
    ...    Log To Console    所有测试执行成功！

    Log To Console    测试执行完成！主报告在 ${OUTPUTDIR}/，详细测试报告在 ${OUTPUTDIR}/${SUBTESTS_DIR}/ 目录