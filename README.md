# Robot Framework Redfish API 测试框架

用于测试BMC软件Redfish接口的自动化测试框架。

## 目录结构

```
├── requirements.txt          # Python依赖
├── setup_and_run.bat       # 安装运行脚本(Windows)
├── requirements_install.bat # 依赖安装脚本(Windows)
├── README.md               # 本文档
├── QUICK_START.md          # 快速开始指南
├── .gitignore              # Git忽略文件
├── testcases/              # 测试用例目录
│   ├── test_pcie_device.robot  # PCIeDevice接口测试用例
│   └── run_all_tests.robot     # 执行所有测试的包装器
├── keywords/               # 自定义关键字
│   └── redfish_keywords.robot # Redfish相关关键字
├── variables/              # 变量定义
│   └── redfish_variables.py   # Redfish变量配置
└── resources/              # 资源文件
    └── redfish_resources.robot # 测试资源
```

## 环境要求

- Python 3.7+
- Robot Framework
- RequestsLibrary
- JSONLibrary

## 安装依赖

```bash
pip install -r requirements.txt
```

## 配置

在 `variables/redfish_variables.py` 中配置Redfish连接信息：

```python
REDFISH_BASE_URL = "https://172.14.8.101"
REDFISH_USERNAME = "admin"
REDFISH_PASSWORD = "Password@_"
```

## 运行测试

### 运行所有测试

```bash
# 通过包装器执行所有测试
robot testcases/run_all_tests.robot

# 或直接运行所有测试用例
robot testcases/
```

### 运行特定测试用例

```bash
robot testcases/test_pcie_device.robot
```

### 按标签运行测试

```bash
robot --include smoke testcases/test_pcie_device.robot
robot --include functional testcases/test_pcie_device.robot
```

### 生成详细报告

```bash
# 使用包装器生成完整报告
robot --outputdir results --log log.html --report report.html testcases/run_all_tests.robot

# 或直接生成单个测试用例报告
robot --outputdir results --log log.html --report report.html testcases/test_pcie_device.robot
```

## 测试用例说明

### run_all_tests.robot

这是一个测试套件包装器，用于执行`testcases/`目录下的所有测试（排除自身）。它会：
1. 创建测试会话
2. 执行所有标记的测试用例
3. 生成综合测试报告
4. 主报告在`results/`目录，详细测试报告在`results/subtests/`目录

### test_pcie_device.robot

测试Redfish接口：`https://172.14.8.101/redfish/v1/Chassis/1/PCIeDevices/11`

包含以下测试场景：

1. **验证PCIeDevice接口可访问性** (smoke)
   - 验证接口返回200状态码

2. **验证PCIeDevice接口响应结构** (functional)
   - 验证响应包含所有必需字段
   - 验证Status字段显示正确状态

3. **验证PCIeDevice接口数据完整性** (functional)
   - 验证@odata.id字段匹配端点
   - 验证@odata.type字段包含PCIeDevice

## 预期响应字段

测试验证以下字段是否存在：

- @odata.id
- @odata.type
- Id
- Name
- Description
- Status
- FirmwareVersion
- Manufacturer
- Model
- SerialNumber
- PartNumber

## Status字段预期值

- State: "Enabled"
- Health: "OK"

## 自定义关键字

### redfish_keywords.robot

提供以下关键字：

1. **Create Redfish Session** - 创建Redfish API会话
2. **Get Redfish Resource** - 获取Redfish资源
3. **Validate Response Status** - 验证响应状态码
4. **Validate Response Has Required Fields** - 验证响应包含必需字段
5. **Validate Status Fields** - 验证Status字段的值
6. **Validate PCIeDevice Response** - 验证PCIeDevice接口响应
7. **Log Response Details** - 记录响应详情
8. **Log All Response Fields** - 记录响应中的所有字段，用于调试

## 扩展框架

### 添加新的测试用例

1. 在 `testcases/` 目录下创建新的 `.robot` 文件
2. 使用现有的关键字或创建新的关键字
3. 在 `keywords/` 目录下添加新的关键字定义
4. 在 `variables/` 目录下添加新的变量配置

### 添加新的API端点测试

1. 在 `variables/redfish_variables.py` 中添加新的端点常量
2. 在 `keywords/redfish_keywords.robot` 中添加新的验证关键字
3. 在 `testcases/` 中创建对应的测试用例文件

## 故障排除

### SSL证书验证错误

如果遇到SSL证书验证错误，框架已禁用证书验证 (`verify=${False}`)。在生产环境中建议使用有效的证书。

### 连接超时

检查BMC IP地址是否正确，确保网络连通性。

### 认证失败

检查用户名和密码是否正确。

### 响应字段不匹配

根据实际的Redfish响应调整 `EXPECTED_FIELDS` 和 `EXPECTED_STATUS` 配置。