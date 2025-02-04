const mach = @import("mach");
const zgui = @import("mach-imgui");

pub fn render_content(core: *mach.Core) !void {
    const window_size = core.getWindowSize();
    zgui.backend.newFrame(
        core,
        window_size.width,
        window_size.height,
    );

    if (!zgui.begin("Demo Settings", .{})) {
        zgui.end();
        return;
    }

    if (zgui.collapsingHeader("Widgets: Main", .{})) {
        zgui.textUnformattedColored(.{ 0, 0.8, 0, 1 }, "Button");
        if (zgui.button("Button 1", .{ .w = 200.0 })) {
            // 'Button 1' pressed.
        }
        zgui.sameLine(.{ .spacing = 20.0 });
        if (zgui.button("Button 2", .{ .h = 60.0 })) {
            // 'Button 2' pressed.
        }
        zgui.sameLine(.{});
        {
            const label = "Button 3 is special ;)";
            const s = zgui.calcTextSize(label, .{});
            _ = zgui.button(label, .{ .w = s[0] + 30.0 });
        }
        zgui.sameLine(.{});
        _ = zgui.button("Button 4", .{});
        _ = zgui.button("Button 5", .{ .w = -1.0, .h = 100.0 });

        zgui.pushStyleColor4f(.{ .idx = .text, .c = .{ 1.0, 0.0, 0.0, 1.0 } });
        _ = zgui.button("  Red Text Button  ", .{});
        zgui.popStyleColor(.{});

        zgui.sameLine(.{});
        zgui.pushStyleColor4f(.{ .idx = .text, .c = .{ 1.0, 1.0, 0.0, 1.0 } });
        _ = zgui.button("  Yellow Text Button  ", .{});
        zgui.popStyleColor(.{});

        _ = zgui.smallButton("  Small Button  ");
        zgui.sameLine(.{});
        _ = zgui.arrowButton("left_button_id", .{ .dir = .left });
        zgui.sameLine(.{});
        _ = zgui.arrowButton("right_button_id", .{ .dir = .right });
        zgui.spacing();

        const static = struct {
            var check0: bool = true;
            var bits: u32 = 0xf;
            var radio_value: u32 = 1;
            var month: i32 = 1;
            var progress: f32 = 0.0;
        };
        zgui.textUnformattedColored(.{ 0, 0.8, 0, 1 }, "Checkbox");
        _ = zgui.checkbox("Magic Is Everywhere", .{ .v = &static.check0 });
        zgui.spacing();

        zgui.textUnformattedColored(.{ 0, 0.8, 0, 1 }, "Checkbox bits");
        zgui.text("Bits value: {b} ({d})", .{ static.bits, static.bits });
        _ = zgui.checkboxBits("Bit 0", .{ .bits = &static.bits, .bits_value = 0x1 });
        _ = zgui.checkboxBits("Bit 1", .{ .bits = &static.bits, .bits_value = 0x2 });
        _ = zgui.checkboxBits("Bit 2", .{ .bits = &static.bits, .bits_value = 0x4 });
        _ = zgui.checkboxBits("Bit 3", .{ .bits = &static.bits, .bits_value = 0x8 });
        zgui.spacing();

        zgui.textUnformattedColored(.{ 0, 0.8, 0, 1 }, "Radio buttons");
        if (zgui.radioButton("One", .{ .active = static.radio_value == 1 })) static.radio_value = 1;
        if (zgui.radioButton("Two", .{ .active = static.radio_value == 2 })) static.radio_value = 2;
        if (zgui.radioButton("Three", .{ .active = static.radio_value == 3 })) static.radio_value = 3;
        if (zgui.radioButton("Four", .{ .active = static.radio_value == 4 })) static.radio_value = 4;
        if (zgui.radioButton("Five", .{ .active = static.radio_value == 5 })) static.radio_value = 5;
        zgui.spacing();

        _ = zgui.radioButtonStatePtr("January", .{ .v = &static.month, .v_button = 1 });
        zgui.sameLine(.{});
        _ = zgui.radioButtonStatePtr("February", .{ .v = &static.month, .v_button = 2 });
        zgui.sameLine(.{});
        _ = zgui.radioButtonStatePtr("March", .{ .v = &static.month, .v_button = 3 });
        zgui.spacing();

        zgui.textUnformattedColored(.{ 0, 0.8, 0, 1 }, "Progress bar");
        zgui.progressBar(.{ .fraction = static.progress });
        static.progress += 0.005;
        if (static.progress > 1.0) static.progress = 0.0;
        zgui.spacing();

        zgui.bulletText("keep going...", .{});
    }

    if (zgui.collapsingHeader("Widgets: Combo Box", .{})) {
        const static = struct {
            var selection_index: u32 = 0;
            var current_item: i32 = 0;
        };

        const items = [_][:0]const u8{ "aaa", "bbb", "ccc", "ddd", "eee", "FFF", "ggg", "hhh" };
        if (zgui.beginCombo("Combo 0", .{ .preview_value = items[static.selection_index] })) {
            for (items) |item, index| {
                const i = @intCast(u32, index);
                if (zgui.selectable(item, .{ .selected = static.selection_index == i }))
                    static.selection_index = i;
            }
            zgui.endCombo();
        }

        _ = zgui.combo("Combo 1", .{
            .current_item = &static.current_item,
            .items_separated_by_zeros = "Item 0\x00Item 1\x00Item 2\x00Item 3\x00\x00",
        });
    }

    if (zgui.collapsingHeader("Widgets: Drag Sliders", .{})) {
        const static = struct {
            var v1: f32 = 0.0;
            var v2: [2]f32 = .{ 0.0, 0.0 };
            var v3: [3]f32 = .{ 0.0, 0.0, 0.0 };
            var v4: [4]f32 = .{ 0.0, 0.0, 0.0, 0.0 };
            var range: [2]f32 = .{ 0.0, 0.0 };
            var v1i: i32 = 0.0;
            var v2i: [2]i32 = .{ 0, 0 };
            var v3i: [3]i32 = .{ 0, 0, 0 };
            var v4i: [4]i32 = .{ 0, 0, 0, 0 };
            var rangei: [2]i32 = .{ 0, 0 };
            var si8: i8 = 123;
            var vu16: [3]u16 = .{ 10, 11, 12 };
            var sd: f64 = 0.0;
        };
        _ = zgui.dragFloat("Drag float 1", .{ .v = &static.v1 });
        _ = zgui.dragFloat2("Drag float 2", .{ .v = &static.v2 });
        _ = zgui.dragFloat3("Drag float 3", .{ .v = &static.v3 });
        _ = zgui.dragFloat4("Drag float 4", .{ .v = &static.v4 });
        _ = zgui.dragFloatRange2(
            "Drag float range 2",
            .{ .current_min = &static.range[0], .current_max = &static.range[1] },
        );
        _ = zgui.dragInt("Drag int 1", .{ .v = &static.v1i });
        _ = zgui.dragInt2("Drag int 2", .{ .v = &static.v2i });
        _ = zgui.dragInt3("Drag int 3", .{ .v = &static.v3i });
        _ = zgui.dragInt4("Drag int 4", .{ .v = &static.v4i });
        _ = zgui.dragIntRange2(
            "Drag int range 2",
            .{ .current_min = &static.rangei[0], .current_max = &static.rangei[1] },
        );
        _ = zgui.dragScalar("Drag scalar (i8)", i8, .{ .v = &static.si8, .min = -20 });
        _ = zgui.dragScalarN(
            "Drag scalar N ([3]u16)",
            @TypeOf(static.vu16),
            .{ .v = &static.vu16, .max = 100 },
        );
        _ = zgui.dragScalar(
            "Drag scalar (f64)",
            f64,
            .{ .v = &static.sd, .min = -1.0, .max = 1.0, .speed = 0.005 },
        );
    }

    if (zgui.collapsingHeader("Widgets: Regular Sliders", .{})) {
        const static = struct {
            var v1: f32 = 0;
            var v2: [2]f32 = .{ 0, 0 };
            var v3: [3]f32 = .{ 0, 0, 0 };
            var v4: [4]f32 = .{ 0, 0, 0, 0 };
            var v1i: i32 = 0;
            var v2i: [2]i32 = .{ 0, 0 };
            var v3i: [3]i32 = .{ 10, 10, 10 };
            var v4i: [4]i32 = .{ 0, 0, 0, 0 };
            var su8: u8 = 1;
            var vu16: [3]u16 = .{ 10, 11, 12 };
            var vsf: f32 = 0;
            var vsi: i32 = 0;
            var vsu8: u8 = 1;
            var angle: f32 = 0;
        };
        _ = zgui.sliderFloat("Slider float 1", .{ .v = &static.v1, .min = 0.0, .max = 1.0 });
        _ = zgui.sliderFloat2("Slider float 2", .{ .v = &static.v2, .min = -1.0, .max = 1.0 });
        _ = zgui.sliderFloat3("Slider float 3", .{ .v = &static.v3, .min = 0.0, .max = 1.0 });
        _ = zgui.sliderFloat4("Slider float 4", .{ .v = &static.v4, .min = 0.0, .max = 1.0 });
        _ = zgui.sliderInt("Slider int 1", .{ .v = &static.v1i, .min = 0, .max = 100 });
        _ = zgui.sliderInt2("Slider int 2", .{ .v = &static.v2i, .min = -20, .max = 20 });
        _ = zgui.sliderInt3("Slider int 3", .{ .v = &static.v3i, .min = 10, .max = 50 });
        _ = zgui.sliderInt4("Slider int 4", .{ .v = &static.v4i, .min = 0, .max = 10 });
        _ = zgui.sliderScalar(
            "Slider scalar (u8)",
            u8,
            .{ .v = &static.su8, .min = 0, .max = 100, .cfmt = "%Xh" },
        );
        _ = zgui.sliderScalarN(
            "Slider scalar N ([3]u16)",
            [3]u16,
            .{ .v = &static.vu16, .min = 1, .max = 100 },
        );
        _ = zgui.sliderAngle("Slider angle", .{ .vrad = &static.angle });
        _ = zgui.vsliderFloat(
            "VSlider float",
            .{ .w = 80.0, .h = 200.0, .v = &static.vsf, .min = 0.0, .max = 1.0 },
        );
        zgui.sameLine(.{});
        _ = zgui.vsliderInt(
            "VSlider int",
            .{ .w = 80.0, .h = 200.0, .v = &static.vsi, .min = 0, .max = 100 },
        );
        zgui.sameLine(.{});
        _ = zgui.vsliderScalar(
            "VSlider scalar (u8)",
            u8,
            .{ .w = 80.0, .h = 200.0, .v = &static.vsu8, .min = 0, .max = 200 },
        );
    }

    if (zgui.collapsingHeader("Widgets: Input with Keyboard", .{})) {
        const static = struct {
            var buf: [128]u8 = undefined;
            var buf1: [128]u8 = undefined;
            var buf2: [128]u8 = undefined;
            var v1: f32 = 0;
            var v2: [2]f32 = .{ 0, 0 };
            var v3: [3]f32 = .{ 0, 0, 0 };
            var v4: [4]f32 = .{ 0, 0, 0, 0 };
            var v1i: i32 = 0;
            var v2i: [2]i32 = .{ 0, 0 };
            var v3i: [3]i32 = .{ 0, 0, 0 };
            var v4i: [4]i32 = .{ 0, 0, 0, 0 };
            var sf64: f64 = 0.0;
            var si8: i8 = 0;
            var v3u8: [3]u8 = .{ 0, 0, 0 };
        };
        _ = zgui.inputText("Input text", .{ .buf = static.buf[0..] });
        _ = zgui.inputTextMultiline("Input text multiline", .{ .buf = static.buf1[0..] });
        _ = zgui.inputTextWithHint("Input text with hint", .{ .hint = "Enter your name", .buf = static.buf2[0..] });
        _ = zgui.inputFloat("Input float 1", .{ .v = &static.v1 });
        _ = zgui.inputFloat2("Input float 2", .{ .v = &static.v2 });
        _ = zgui.inputFloat3("Input float 3", .{ .v = &static.v3 });
        _ = zgui.inputFloat4("Input float 4", .{ .v = &static.v4 });
        _ = zgui.inputInt("Input int 1", .{ .v = &static.v1i });
        _ = zgui.inputInt2("Input int 2", .{ .v = &static.v2i });
        _ = zgui.inputInt3("Input int 3", .{ .v = &static.v3i });
        _ = zgui.inputInt4("Input int 4", .{ .v = &static.v4i });
        _ = zgui.inputDouble("Input double", .{ .v = &static.sf64 });
        _ = zgui.inputScalar("Input scalar (i8)", i8, .{ .v = &static.si8 });
        _ = zgui.inputScalarN("Input scalar N ([3]u8)", [3]u8, .{ .v = &static.v3u8 });
    }

    if (zgui.collapsingHeader("Widgets: Color Editor/Picker", .{})) {
        const static = struct {
            var col3: [3]f32 = .{ 0, 0, 0 };
            var col4: [4]f32 = .{ 0, 0, 0, 0 };
            var col3p: [3]f32 = .{ 0, 0, 0 };
            var col4p: [4]f32 = .{ 0, 0, 0, 0 };
        };
        _ = zgui.colorEdit3("Color edit 3", .{ .col = &static.col3 });
        _ = zgui.colorEdit4("Color edit 4", .{ .col = &static.col4 });
        _ = zgui.colorPicker3("Color picker 3", .{ .col = &static.col3p });
        _ = zgui.colorPicker4("Color picker 4", .{ .col = &static.col4p });
        _ = zgui.colorButton("color_button_id", .{ .col = .{ 0, 1, 0, 1 } });
    }

    if (zgui.collapsingHeader("Widgets: Trees", .{})) {
        if (zgui.treeNodeStrId("tree_id", "My Tree {d}", .{1})) {
            zgui.textUnformatted("Some content...");
            zgui.treePop();
        }
        if (zgui.collapsingHeader("Collapsing header 1", .{})) {
            zgui.textUnformatted("Some content...");
        }
    }

    if (zgui.collapsingHeader("Widgets: List Boxes", .{})) {
        const static = struct {
            var selection_index: u32 = 0;
        };
        const items = [_][:0]const u8{ "aaa", "bbb", "ccc", "ddd", "eee", "FFF", "ggg", "hhh" };
        if (zgui.beginListBox("List Box 0", .{})) {
            for (items) |item, index| {
                const i = @intCast(u32, index);
                if (zgui.selectable(item, .{ .selected = static.selection_index == i }))
                    static.selection_index = i;
            }
            zgui.endListBox();
        }
    }

    const draw_list = zgui.getWindowDrawList();
    draw_list.pushClipRect(.{ .pmin = .{ 0, 0 }, .pmax = .{ 400, 400 } });
    draw_list.addLine(.{ .p1 = .{ 0, 0 }, .p2 = .{ 400, 400 }, .col = 0xff_ff_00_ff, .thickness = 5.0 });
    draw_list.popClipRect();

    draw_list.pushClipRectFullScreen();
    draw_list.addRectFilled(.{
        .pmin = .{ 100, 100 },
        .pmax = .{ 300, 200 },
        .col = 0xff_ff_ff_ff,
        .rounding = 25.0,
    });
    draw_list.addRectFilledMultiColor(.{
        .pmin = .{ 100, 300 },
        .pmax = .{ 200, 400 },
        .col_upr_left = 0xff_00_00_ff,
        .col_upr_right = 0xff_00_ff_00,
        .col_bot_right = 0xff_ff_00_00,
        .col_bot_left = 0xff_00_ff_ff,
    });
    draw_list.addQuadFilled(.{
        .p1 = .{ 150, 400 },
        .p2 = .{ 250, 400 },
        .p3 = .{ 200, 500 },
        .p4 = .{ 100, 500 },
        .col = 0xff_ff_ff_ff,
    });
    draw_list.addQuad(.{
        .p1 = .{ 170, 420 },
        .p2 = .{ 270, 420 },
        .p3 = .{ 220, 520 },
        .p4 = .{ 120, 520 },
        .col = 0xff_00_00_ff,
        .thickness = 3.0,
    });
    draw_list.addText(.{ 130, 130 }, 0xff_00_00_ff, "The number is: {}", .{7});
    draw_list.addCircleFilled(.{ .p = .{ 200, 600 }, .r = 50, .col = 0xff_ff_ff_ff });
    draw_list.addCircle(.{ .p = .{ 200, 600 }, .r = 30, .col = 0xff_00_00_ff, .thickness = 11 });
    draw_list.addPolyline(
        &.{ .{ 100, 700 }, .{ 200, 600 }, .{ 300, 700 }, .{ 400, 600 } },
        .{ .col = 0xff_00_aa_11, .thickness = 7 },
    );
    _ = draw_list.getClipRectMin();
    _ = draw_list.getClipRectMax();
    draw_list.popClipRect();

    zgui.end();
}
