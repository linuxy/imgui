const std = @import("std");
const zgui = @import("zgui.zig");
const mach = @import("mach");

pub const c = @cImport({
    @cInclude("imgui_c_keys.h");
});

pub fn machKeyToImgui(key: mach.Key) u32 {
    return switch (key) {
        .tab => c.ImGuiKey_Tab,
        .backspace => c.ImGuiKey_Backspace,
        .delete => c.ImGuiKey_Delete,
        .page_up => c.ImGuiKey_PageUp,
        .page_down => c.ImGuiKey_PageDown,
        .home => c.ImGuiKey_Home,
        .insert => c.ImGuiKey_Insert,
        .space => c.ImGuiKey_Space,

        .left => c.ImGuiKey_LeftArrow,
        .right => c.ImGuiKey_RightArrow,
        .up => c.ImGuiKey_UpArrow,
        .down => c.ImGuiKey_DownArrow,

        .a => c.ImGuiKey_A,
        .b => c.ImGuiKey_B,
        .c => c.ImGuiKey_C,
        .d => c.ImGuiKey_D,
        .e => c.ImGuiKey_E,
        .f => c.ImGuiKey_F,
        .g => c.ImGuiKey_G,
        .h => c.ImGuiKey_H,
        .i => c.ImGuiKey_I,
        .j => c.ImGuiKey_J,
        .k => c.ImGuiKey_K,
        .l => c.ImGuiKey_L,
        .m => c.ImGuiKey_M,
        .n => c.ImGuiKey_N,
        .o => c.ImGuiKey_O,
        .p => c.ImGuiKey_P,
        .q => c.ImGuiKey_Q,
        .r => c.ImGuiKey_R,
        .s => c.ImGuiKey_S,
        .t => c.ImGuiKey_T,
        .u => c.ImGuiKey_U,
        .v => c.ImGuiKey_V,
        .w => c.ImGuiKey_W,
        .x => c.ImGuiKey_X,
        .y => c.ImGuiKey_Y,
        .z => c.ImGuiKey_Z,

        else => c.ImGuiKey_None,
    };
}

pub fn init(wgpu_device: *const anyopaque, rt_format: u32) void {
    if (!ImGui_ImplWGPU_Init(wgpu_device, 1, rt_format)) {
        unreachable;
    }
}

pub fn deinit() void {
    ImGui_ImplWGPU_Shutdown();
}

pub fn newFrame(core: *mach.Core, fb_width: u32, fb_height: u32) void {
    ImGui_ImplWGPU_NewFrame();

    zgui.io.setDisplaySize(@intToFloat(f32, fb_width), @intToFloat(f32, fb_height));

    const window_size = core.getWindowSize();
    const fb_size = core.getFramebufferSize();
    zgui.io.setDisplayFramebufferScale(
        @intToFloat(f32, window_size.width) / @intToFloat(f32, fb_size.width),
        @intToFloat(f32, window_size.height) / @intToFloat(f32, fb_size.height),
    );

    zgui.newFrame();
}

pub fn draw(wgpu_render_pass: *const anyopaque) void {
    zgui.render();
    ImGui_ImplWGPU_RenderDrawData(zgui.getDrawData(), wgpu_render_pass);
}

pub fn passEvent(event: mach.Event) void {
    switch (event) {
        .mouse_motion => {
            const pos = event.mouse_motion.pos;
            ImGui_ImplMach_CursorPosCallback(pos.x, pos.y);
        },
        .mouse_press => {
            ImGui_ImplMach_MouseButtonCallback(0, 1, 0);
        },
        .mouse_release => {
            ImGui_ImplMach_MouseButtonCallback(0, 0, 0);
        },
        .mouse_scroll => {
            const offsets = event.mouse_scroll;
            ImGui_ImplMach_MouseScrollCallback(offsets.xoffset, offsets.yoffset);
        },
        .key_press => {
            const key = event.key_press.key;
            const keycode = machKeyToImgui(key);
            ImGui_ImplMach_KeyCallback(keycode, 0, 1, 0);
        },
        .key_release => {
            const key = event.key_release.key;
            const keycode = machKeyToImgui(key);
            ImGui_ImplMach_KeyCallback(keycode, 0, 0, 0);
        },
        .char_input => {
            ImGui_ImplMach_CharCallback(event.char_input.codepoint);
        },
        else => {},
    }
}

// Rendering
extern fn ImGui_ImplWGPU_Init(device: *const anyopaque, num_frames_in_flight: u32, rt_format: u32) bool;
extern fn ImGui_ImplWGPU_NewFrame() void;
extern fn ImGui_ImplWGPU_RenderDrawData(draw_data: *const anyopaque, pass_encoder: *const anyopaque) void;
extern fn ImGui_ImplWGPU_Shutdown() void;

// Input events
extern fn ImGui_ImplMach_CursorPosCallback(x: f64, y: f64) void;
extern fn ImGui_ImplMach_MouseButtonCallback(button: u32, action: u32, mods: u32) void;
extern fn ImGui_ImplMach_MouseScrollCallback(xoffset: f64, yoffset: f64) void;
extern fn ImGui_ImplMach_KeyCallback(keycode: u32, scancode: u32, action: u32, mods: u32) void;
extern fn ImGui_ImplMach_CharCallback(c: u32) void;
