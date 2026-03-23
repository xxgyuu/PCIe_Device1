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

## 7. Jenkins CI/CD 集成

### 7.1 环境要求
Jenkins节点必须安装：
1. **Python 3.6+** - 测试框架依赖
2. **Git** - 代码版本控制

### 7.2 在Jenkins中配置Python

#### 方法一：在节点上安装Python
1. 下载并安装Python 3.6+
2. **重要**：安装时勾选 "Add Python to PATH"
3. 验证安装：
   ```batch
   python --version
   python -m pip --version
   ```

#### 方法二：使用Jenkins Python工具（推荐）
1. Jenkins管理 → 全局工具配置
2. 添加Python安装：
   - 名称：Python3
   - 自动安装：勾选
   - 从python.org安装：勾选
   - 版本：选择3.x
3. 在构建步骤中引用Python工具

#### 方法三：在批处理脚本中设置PATH
如果Python安装在非标准位置，修改 `setup_and_run.bat` 开头：
```batch
@echo off
:: 设置Python路径（根据实际安装位置修改）
set PATH=C:\Python39;C:\Python39\Scripts;%PATH%

echo ========================================
echo Redfish API 测试框架安装与运行脚本
echo ========================================
...
```

### 7.3 Jenkins构建步骤配置
1. 创建自由风格项目
2. 源码管理：Git
   - 仓库URL：`https://github.com/xxgyuu/PCIe_Device1.git`
3. 构建触发器：按需配置
4. 构建环境：按需配置
5. 构建步骤：
   - **执行Windows批处理命令**：
     ```batch
     setup_and_run.bat
     ```
6. 构建后操作：
   - **Allure报告**（如已安装Allure插件）：
     - 路径：`allure-results`
     - 报告路径：`allure-report`

### 7.4 常见Jenkins构建问题

#### 问题：Python未找到
**症状**：`'python' 不是内部或外部命令`
**解决**：
1. 确保Python已安装并添加到PATH
2. 或在批处理脚本开头设置PATH

#### 问题：依赖安装失败
**症状**：`pip install` 失败
**解决**：
1. 检查网络连接
2. 尝试使用国内镜像源（修改 `setup_and_run.bat`）：
   ```batch
   python -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
   ```

#### 问题：测试连接失败
**症状**：`ConnectionError` 或 `Timeout`
**解决**：
1. 检查BMC IP是否可达
2. 确认防火墙设置
3. 在 `variables/redfish_variables.py` 中更新IP地址

### 7.5 自动化构建示例
完整构建流程：
1. 拉取代码 → 安装依赖 → 运行测试 → 生成报告
2. 可通过 `testcases/run_all_tests.robot` 运行所有测试
3. 测试结果输出到 `results/` 目录
4. Allure报告提供详细的测试分析