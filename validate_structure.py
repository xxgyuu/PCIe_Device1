#!/usr/bin/env python3
"""
验证Robot Framework测试框架结构
"""
import os
import sys

def check_file_exists(file_path, description):
    if os.path.exists(file_path):
        print(f"✓ {description}: {file_path}")
        return True
    else:
        print(f"✗ {description}: {file_path} - 文件不存在")
        return False

def main():
    print("验证Robot Framework测试框架结构...")
    print("=" * 60)

    required_files = [
        ("requirements.txt", "依赖文件"),
        ("testcases/test_pcie_device.robot", "测试用例文件"),
        ("keywords/redfish_keywords.robot", "关键字文件"),
        ("variables/redfish_variables.py", "变量文件"),
        ("resources/redfish_resources.robot", "资源文件"),
    ]

    optional_files = [
        ("run_tests.robot", "主测试套件文件"),
        ("setup_and_run.bat", "安装运行脚本"),
        ("requirements_install.bat", "依赖安装脚本"),
        ("README.md", "文档文件"),
    ]

    all_ok = True

    print("\n必需文件:")
    for file_path, description in required_files:
        if not check_file_exists(file_path, description):
            all_ok = False

    print("\n可选文件:")
    for file_path, description in optional_files:
        check_file_exists(file_path, description)

    print("\n" + "=" * 60)

    if all_ok:
        print("✓ 所有必需文件都存在，框架结构完整。")
        print("\n使用说明:")
        print("1. 安装依赖: pip install -r requirements.txt")
        print("2. 运行测试: robot testcases/test_pcie_device.robot")
        print("3. 或运行: setup_and_run.bat")
        return 0
    else:
        print("✗ 缺少必需文件，请检查框架结构。")
        return 1

if __name__ == "__main__":
    sys.exit(main())