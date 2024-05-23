# FPGA-project

数逻期末 project

## git 协作方法

说明，为了使用 git 协作编辑 Vivado 项目并进行版本管理，使用 tcl 来创建和更新工程，使用方法：

```powershell
vivado -mode tcl -source create_project.tcl
```

每次在 Vivado 中创建新的资源时，请从 Tcl Console 中拷贝创建资源的命令，并在 create_project.tcl 中添加到相应位置。

每次 pull 时，可以手动查看 tcl 脚本里的更改，并在 Vivado 中的 Tcl Console 中运行。

## Vscode 插件

推荐安装[Digital IDE 插件](https://sterben.nitcloud.cn/zh/)，并在设置里配置 Vivado 路径。

## 生成 coe 文件

```bash
python ./script/image2coe.py ./image/bg.jpg
```

## 参考资料

[Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)

[SWORD 4.0 xdc 约束文件](http://www.sword.org.cn/sites/default/files/SWORD4.xdc)

[CSDN: FPGA 实战（五）时钟 IP 核（MMCM PLL）](https://blog.csdn.net/weixin_51944426/article/details/120225274)

[[野火]FPGA Verilog 开发实战指南](https://doc.embedfire.com/fpga/altera/ep4ce10_pro/zh/latest)
