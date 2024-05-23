# FPGA-project

数逻期末project

## git协作方法

说明，为了使用git协作编辑Vivado项目并进行版本管理，使用tcl来创建和更新工程，使用方法：

```powershell
vivado -mode tcl -source create_project.tcl
```

每次在Vivado中创建新的资源时，请从Tcl Console中拷贝创建资源的命令，并在create_project.tcl中添加到相应位置。

每次pull时，可以手动查看tcl脚本里的更改，并在Vivado中的Tcl Console中运行。

## Vscode插件

推荐安装[Digital IDE插件](https://sterben.nitcloud.cn/zh/)，并在设置里配置Vivado路径。

## 生成coe文件

```bash
python ./script/image2coe.py ./image/bg.jpg
```

## 参考资料

[Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)

[SWORD 4.0 xdc约束文件](http://www.sword.org.cn/sites/default/files/SWORD4.xdc)

[CSDN: FPGA实战（五）时钟IP核（MMCM PLL）](https://blog.csdn.net/weixin_51944426/article/details/120225274)

[[野火]FPGA Verilog开发实战指南](https://doc.embedfire.com/fpga/altera/ep4ce10_pro/zh/latest)
