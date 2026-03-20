# 快速开始

## 1. 安装依赖

### 方法一：使用批处理脚本（Windows）
```
requirements_install.bat
```

### 方法二：手动安装
```bash
pip install -r requirements.txt
```

## 2. 运行测试

### 方法一：使用批处理脚本（Windows）
```
setup_and_run.bat
```

### 方法二：手动运行
```bash
# 运行所有测试（通过run_all_tests.robot包装器）
robot testcases/run_all_tests.robot

# 或直接运行PCIeDevice测试
robot testcases/test_pcie_device.robot

# 生成详细报告
robot --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

# 按标签运行测试
robot --include smoke testcases/test_pcie_device.robot
robot --include functional testcases/test_pcie_device.robot
```

## 3. 测试目标

测试Redfish接口：`https://172.14.8.101/redfish/v1/Chassis/1/PCIeDevices/11`

使用凭证：
- 用户名：admin
- 密码：Password@_

## 4. 预期验证

1. 接口返回200状态码
2. 响应包含所有必需字段
3. Status字段显示正确状态（State: Enabled, Health: OK）
4. @odata.id字段匹配端点
5. @odata.type字段包含PCIeDevice

## 5. 自定义配置

编辑 `variables/redfish_variables.py` 文件修改：
- BMC IP地址
- 用户名和密码
- 预期响应字段
- 预期状态值

## 6. 故障排除

### SSL证书错误
框架已禁用SSL证书验证。如需启用，修改 `keywords/redfish_keywords.robot` 中的 `verify=${False}` 为 `verify=${True}`。

### 连接失败
- 检查BMC IP地址是否正确
- 检查网络连通性
- 检查用户名和密码

### 响应字段不匹配
根据实际Redfish响应调整 `variables/redfish_variables.py` 中的 `EXPECTED_FIELDS` 和 `EXPECTED_STATUS`。

### 查看实际响应字段
如需查看API实际返回的字段，可在测试用例中添加：
```
Log All Response Fields    ${RESPONSE}
```
或在 `keywords/redfish_keywords.robot` 中临时添加该关键字调用。