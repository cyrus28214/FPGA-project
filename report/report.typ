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

我们通过Verilog语言实现了基于FPGA的魔塔游戏。

= 核心模块说明与仿真

= 调试过程分析

= 小组主要工作说明

== 参考项目

#v(0.5em)

- *HTML5魔塔小游戏*（#linkx("https://h5mota.com/games/24/", "在线演示")、#linkx("https://github.com/ckcz123/mota-js", "项目地址")）：主要参考游戏玩法，也是游戏素材来源。

// - *ChatGPT*：询问一些简单问题，如如何将PNG文件转化为COE文件。

- [Vivado Design Suite Tcl Command Reference Guide](https://docs.amd.com/r/en-US/ug835-vivado-tcl-commands)
- [SWORD 4.0 xdc 约束文件](http://www.sword.org.cn/sites/default/files/SWORD4.xdc)
- [CSDN: FPGA 实战（五）时钟 IP 核（MMCM PLL）](https://blog.csdn.net/weixin_51944426/article/details/120225274)
- [[野火]FPGA Verilog 开发实战指南](https://doc.embedfire.com/fpga/altera/ep4ce10_pro/zh/latest)

== 小组工作说明

== 各成员贡献比例

各成员工作比例均等。
