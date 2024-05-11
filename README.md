# FPGA-project

数逻期末project

## git协作方法

说明，为了使用git协作编辑Vivado项目并进行版本管理，使用tcl来创建和更新工程，使用方法：

```powershell
vivado -mode tcl -source create_project.tcl
```

每次在Vivado中创建新的资源时，请从Tcl Console中拷贝创建资源的命令，并在create_project.tcl中添加到相应位置。

每次pull时，可以手动查看tcl脚本里的更改，并在Vivado中的Tcl Console中运行。
