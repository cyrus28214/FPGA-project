#import "./template.typ": *

#show: project.with(
  course: "数字逻辑设计",
  title: [基于FPGA的魔塔游戏],
  semester: "2023-2024 Spring & Summer",
  author: "刘仁钦、黄钰、吴与伦",
  date: "2024年06月20日",
  college: "计算机科学与技术学院",
  major: "计算机科学与技术",
  teacher: "刘海风 (TA: 郭家豪)",
  theme: "lab",
)

#let centerx(it) = align(center, it)
#let linkx(url, name) = {
  link(
    url,
    underline(
      name + "↗",
      offset: 2pt,
    ),
  )
}

#set heading(numbering: (..args) => {
  let nums = args.pos()
  if nums.len() == 1 {
    return numbering("一、", ..nums)
  } else {
    return numbering("1.1)", ..nums)
  }
})

= 设计说明

== 游戏玩法

我们通过Verilog语言实现了基于FPGA的魔塔游戏。其基本游玩规则如下：

- 使用上、下、左、右键控制玩家移动。
- 玩家走到钥匙位置时可以捡起钥匙，用于打开对应颜色的门。
- 玩家走到药水位置时可以增加血量，用于和怪物消耗。
- 当玩家走到楼梯位置时，会在不同楼层的地图之间进行切换。

相比于原版的魔塔，我们实现的魔塔游戏，没有攻击力的设定，按照原版魔塔的设定可以认为玩家和怪物的攻击力都是1，所以能不能打过就是血量比较。

== 开发说明

- #[
    使用 tcl 来创建和更新工程，使用方法：

    ```shell
    vivado -mode tcl -source create_project.tcl
    ```

    每次在 Vivado 中创建新的资源时，需要从 Tcl Console 中拷贝创建资源的命令，并粘贴到 `create_project.tcl` 中的相应位置。
  ]

- 使用 `script/gen_coe.py` 生成coe文件。

- #[
    使用VSCode的#linkx("https://marketplace.visualstudio.com/items?itemName=eirikpre.systemverilog", "eirikpre.systemverilog") 插件实现代码格式化，相关配置如下：

    ```json
    {
    	"systemverilog.compileOnSave": true,
    	"systemverilog.formatCommand": "verible-verilog-format --column_limit 200 --indentation_spaces 3 --wrap_spaces 3 --formal_parameters_indentation indent --named_parameter_indentation indent --named_port_indentation indent --port_declarations_indentation indent"
    }
    ```
  ]

= 核心模块说明与仿真

== 主逻辑

我们首先对时钟频率进行了分时。一个重要思想是将原先的时钟频率分为一些较慢的时钟频率，这样能够保准读写内存的操作在两个正边沿之间就能完成。

游戏的功能实现主要可以分为几个部分：

- 地图渲染：我们最后实现的地图渲染是依次渲染所有格子。注意到原来的素材是透明背景的，但是我们在真正渲染的时候如果位置上是钥匙、怪物或者玩家，则下一层一定是地板，所以我们在将PNG文件转化为coe文件时，直接叠了一层背景在素材下面，这样也不需要在实现的时候进行多层渲染。
- 数字渲染：渲染了生命还有四种钥匙的个数。首先是将二进制数转换为十进制数，并分配到对应位置，渲染时从内存中读出数字的图片并进行渲染。
- 玩家位移：为了方便和内存读写进行统一，在每次移动时，我们先假装让玩家移动到下一位置，从内存中读出这一位置的地图信息，然后判断是否撞墙、是否遇到怪物且打不过，是否遇到门且没有相应钥匙解锁。如果是的话，就回到上一位置并等待下一次移动判断。否则，认为这次移动成功，处理对应的坐标、血量、钥匙数等信息。

== VGA显示

将bRAM中的一块区域与显示器形成映射，VGA模块根据相应规则扫描bRAM中的数据并输出到显示器上。其他模块（如地图渲染模块）通过对bRAM的读写来完成渲染操作。

我们在VGA模块中根据VGA时序规则实现了显示功能，可以分为行扫描和场扫描，具体代码在 `vga.v` 文件中。

#align(center, image("images/2024-06-20-20-57-52.png", width: 80%))

== PS2键盘输入

通过一个串转并模块来读取键盘输入，并传给主逻辑部分进行处理。

== 地图编辑器

我们是实现了xlsx文件与地图设计文件的转换脚本，从而可以在Microsoft Excel软件中利用条件格式功能进行地图设计。

#align(center, image("images/2024-06-20-17-21-37.png", width: 60%))

== 背景音乐播放

将12平均律中每一个半音的频率存入代码中，并通过传入编号的方式来播放对应频率的音符，从而实现音乐播放。可以通过其他软件编写midi文件，并将midi文件转化为乐谱编码，从而实现背景音乐的存储与播放。我们自行从魔塔的背景音乐中扒了一段和弦进行下来作为背景音乐。

== 仿真

PS2 模块的仿真如下：

#align(center, image("images/2024-06-20-21-33-29.png", width: 100%))

更多仿真文件在 `sim/` 文件夹中，其中部分仿真文件可能因为后续接口改动而变得不可用，不过上板验证可知功能都是可以正常运行的。

= 调试过程分析

我们使用模块化的开发方式，如果某个单元模块（如显示、音乐模块等等）出现问题，我们可以通过大眼法或仿真来调试。如果模块之间的整体工作出现问题，则可以用大眼法或上板调试。

此外我们还采用了小黄鸭调试法：即抓另一名小组队友当做“小黄鸭”，给他分析代码的逻辑，并在这一过程中发现问题。

= 小组主要工作说明

== 参考链接

我们自行编写核心代码，下面是实现过程中参考过的一些素材和文档：

- *HTML5魔塔小游戏*（#linkx("https://h5mota.com/games/24/", "在线演示")、#linkx("https://github.com/ckcz123/mota-js", "项目地址")）：主要参考游戏玩法，也是游戏素材来源。

- *Vivado Design Suite Tcl Command Reference Guide* #linkx("https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands", [])：用于配置基于TCL的Vivado项目。

- *SWORD 4.0 约束文件* (#linkx("http://www.sword.org.cn/sites/default/files/SWORD4.xdc", [])), SWORD 中国：下载约束文件。

- *FPGA 实战（五）：时钟 IP 核（MMCM PLL）* (#linkx("https://blog.csdn.net/weixin_51944426/article/details/120225274", [])), 班花i, CSDN：主要参考IP核实现。

- *FPGA Verilog 开发实战指南* (#linkx("https://doc.embedfire.com/fpga/altera/ep4ce10_pro/zh/latest", "")), 野火：主要参考 Verilog 语法。

- *FPGA JOJO 游戏* (#linkx("https://github.com/PAN-Ziyue/FPGA--JOJO/blob/master/JOJO/Framework/PS2.v", "")), PAN-Ziyue, Github.com：参考了PS2模块的实现并进行了重写。

- *瓜豪的实验文档* (#linkx("https://guahao31.github.io/2024_DD/", ""))：也从日常Lab中参考了一些代码。

// - *ChatGPT*：询问一些简单问题，如如何将PNG文件转化为COE文件。

== 小组工作说明

关于我们小组实现的主要功能，请参见 *二、核心模块说明与仿真*。

== 各成员贡献比例

各成员工作比例相当。

#align(center, image("images/2024-06-20-22-01-14.png", width: 50%))

== 小组成员生活照

#align(center, image("images/2024-06-20-17-24-20.png", width: 100%))

== 致谢

感谢刘海风老师的悉心教学与无私帮助。

感谢郭家豪助教的耐心指导与详细解答，让我们的项目开发少走了很多弯路。