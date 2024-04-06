workspace "GLFW"
    architecture "x64"
    configurations { "Debug", "Release" }

project "glfw"
    kind "StaticLib"
    language "C"

    targetdir ("bin/%{cfg.buildcfg}")
    objdir ("bin-int/%{cfg.buildcfg}")

    -- Linux

    filter "system:Linux"

    files {
        "src/internal.h",
        "src/mappings.h",
        "src/context.c",
        "src/init.c",
        "src/input.c",
        "src/monitor.c",
        "src/vulkan.c",
        "src/window.c",
    }

    -- Windows
    filter "system:windows"
        defines { "_GLFW_WIN32", "_CRT_SECURE_NO_WARNINGS" }

        systemversion "latest"

        targetname "glfw3"

    files {
        "include/GLFW/glfw3.h",
        "include/GLFW/glfw3native.h",
        "src/glfw_config.h",
        "src/context.c",
        "src/init.c",
        "src/input.c",
        "src/monitor.c",
        "src/null_init.c",
        "src/null_joystick.c",
        "src/null_monitor.c",
        "src/null_window.c",
        "src/platform.c",
        "src/vulkan.c",
        "src/window.c",
        "src/win32_init.c",
        "src/win32_joystick.c",
        "src/win32_module.c",
        "src/win32_monitor.c",
        "src/win32_time.c",
        "src/win32_thread.c",
        "src/win32_window.c",
        "src/wgl_context.c",
        "src/egl_context.c",
        "src/osmesa_context.c"
    }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"


local function removeMakefiles(path)
    if os.isdir(path) then
        local files = os.matchfiles(path .. "/*")
        for _, file in ipairs(files) do
            if os.isfile(file) then
                local filename = path .. "/" .. file
                if filename:find("Makefile", 1, true) or filename:find("makefile", 1, true) then
                    os.remove(filename)
                end
            elseif os.isdir(file) then
                removeMakefiles(file)
            end
        end
    end
end

newaction {
    trigger = "clean",
    description = "Clean the build",
    execute = function()
        print("Cleaning...")

        -- Clean the bin directory
        os.rmdir("bin")

        -- Clean the obj directory
        os.rmdir("bin-int")

        -- Editor config files
        os.rmdir(".vs")
        os.rmdir(".vscode")

        -- Clean the generated makefiles
        removeMakefiles(".")

        os.remove("glfw.make")
    
        os.remove("GLFW.sln")
        os.remove("glfw.vcxproj")
        os.remove("glfw.vcxproj.user")
        os.remove("glfw.vcxproj.filters")
    end
}
