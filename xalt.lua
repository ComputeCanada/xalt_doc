-- Uncomment this to track GPU usage
-- setenv("XALT_GPU_TRACKING",              "yes")

local root  = "/home/billy/xalt/xalt"  --> Change to match your site!!!

conflict("xalt")

prepend_path{"PATH",          pathJoin(root, "bin"), priority=100}
prepend_path("XALT_DIR",      root)
prepend_path("LD_PRELOAD",    pathJoin(root, "lib64/libxalt_init.so"))
prepend_path("COMPILER_PATH", pathJoin(root, "bin"))

setenv("XALT_DIR", root)
setenv("XALT_ETC_DIR", pathJoin(root, "etc"))
setenv("XALT_EXECUTABLE_TRACKING", "yes")
setenv("XALT_GPU_TRACKING", "no")
setenv("XALT_SCALAR_SAMPLING", "yes")

-- Uncomment these two lines to use XALT inside Singularity containers
setenv("SINGULARITYENV_LD_PRELOAD", pathJoin(root,"lib64/libxalt_init.so"))
prepend_path("SINGULARITY_BINDPATH", root)

------------------------------------------------------------
-- Only set this in production not for testing!!!
-- setenv("XALT_SAMPLING",  "yes")
