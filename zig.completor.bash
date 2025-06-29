# shellcheck disable=2034
# The output path is relative to current config file.
output=_zig.bash
maintainers=('ADoyle (adoyle.h@gmail.com)')
notice='Current no completions for zig commands: cc c++ lib'

cmd=zig
cmd_opts=(-h --help)

subcmds=(
  build fetch init
  build-exe build-lib build-obj test run
  ast-check fmt reduce translate-c
  ar cc c++ dlltool lib ranlib objcopy rc
  env help std libc targets version zen
)

word_to_varname=(
  [c++]=cpp
)

reply_zig_file=(
  'reply_files_in_pattern'
  '\.(zig|zir|zon|o|obj|lib|a|so|dll|dylib|tbd|s|S|c|cxx|cc|C|cpp|stub|m|mm|bc|cu)$'
)

reply_build_steps() {
  local words=( $(zig build --list-steps 2>/dev/null | grep -Eo '^\s*\w+' | grep -Eo '\w+') )
  
  [ $? = 0 ] || return 1

  COMPREPLY=( $(compgen -W "${words[*]}" -- "$cur") )
}

subcmd_opts__fallback='--help'

subcmd_opts_build=(
  -p:@dirs
  --prefix:@dirs
  --prefix-lib-dir:@dirs
  --prefix-exe-dir:@dirs
  --prefix-include-dir:@dirs

  --release=:'fast,safe,small'

  -fdarling -fno-darling
  -fqemu -fno-qemu
  --glibc-runtimes:@files
  -frosetta -fno-rosetta
  -fwasmtime -fno-wasmtime
  -fwine -fno-wine

  -h --help
  -l --list-steps
  --verbose
  --color:'auto,off,on'
  --prominent-compile-errors
  --summary:'all,new,failures,none'
  -j:@hold
  --maxrss:@hold
  --skip-oom-steps
  --fetch
  --watch
  --fuzz
  --debounce:@hold
  -fincremental -fno-incremental

  -Dtarget=
  -Dcpu=
  -Dofmt=
  -Ddynamic-linker=
  -Doptimize=:'Debug,ReleaseSafe,ReleaseFast,ReleaseSmall'

  --search-prefix:@dirs
  --sysroot:@dirs
  --libc:@files

  --system:@dirs
  -fsys= -fno-sys=

  -freference-trace:@hold
  -fno-reference-trace

  --build-file:@files
  --cache-dir:@dirs
  --global-cache-dir:@dirs
  --zig-lib-dir:@dirs
  --build-runner:@files
  --seed:@hold

  --debug-log:@hold
  --debug-pkg-config
  --debug-rt
  --verbose-link
  --verbose-air
  --verbose-llvm-ir:@hold
  --verbose-llvm-bc=:@files
  --verbose-cimport
  --verbose-cc
  --verbose-llvm-cpu-features
)
# https://ziglearn.org/chapter-3/#build-steps
subcmd_args_build=@build_steps
subcmd_args_build_fallback='install,uninstall,run,test'
subcmd_opts_build_fallback=@files

subcmd_opts_fmt=(
  -h --help
  --color:'auto,off,on'
  --stdin
  --check
  --ast-check
  --exclude:@zig_file
)
subcmd_args_fmt=@zig_file

subcmd_opts_libc=(
  -h --help
  -target:@hold
  -includes
)
subcmd_args_libc=@zig_file

subcmd_opts_ar=(
  --format:'default,gnu,darwin,bsd,bigarchive'
  --plugin=
  -h --help
  --output
  --rsp-quoting:'posix,windows'
  --thin
  --version
  -X32
  -X64
  -X32_64
  -X:@hold
  @:@files
)
subcmd_args_ar=@zig_file

subcmd_opts_ast_check=(
  -h --help
  --color:'auto,off,on'
  -t
)
subcmd_args_ast_check=@zig_file

opts_run_general=(
  -h --help
  --watch
  --color:'auto,off,on'
  -femit-bin:@files -fno-emit-bin
  -femit-asm:@files -fno-emit-asm
  -femit-llvm-ir:@files -fno-emit-llvm-ir
  -femit-llvm-bc:@files -fno-emit-llvm-bc
  -femit-h:@files -fno-emit-h
  -femit-docs:@dirs -fno-emit-docs
  -femit-analysis:@files -fno-emit-analysis
  -femit-implib:@files -fno-emit-implib
  --show-builtin
  --cache-dir:@dirs
  --global-cache-dir:@dirs
  --zig-lib-dir:@dirs
  --enable-cache
)

opts_run_compile=(
  -target:@hold
  -mcpu:@hold
  -mcmodel=:'default,tiny,small,kernel,medium,large'
  -mred-zone -mno-red-zone
  -fomit-frame-pointer:@hold -fno-omit-frame-pointer
  -mexec-model=
  --name:@hold
  -O:'Debug,ReleaseFast,ReleaseSafe,ReleaseSmall'
  --pkg-begin:@hold
  --pkg-end
  --main-pkg-path:@dirs
  -fPIC -fno-PIC
  -fPIE -fno-PIE
  -flto -fno-lto
  -fstack-check -fno-stack-check
  -fstack-protector -fno-stack-protector
  -fsanitize-c -fno-sanitize-c
  -fvalgrind -fno-valgrind
  -fsanitize-thread -fno-sanitize-thread
  -fdll-export-fns -fno-dll-export-fns
  -funwind-tables -fno-unwind-tables
  -fLLVM -fno-LLVM
  -fClang -fno-Clang
  -fstage1 -fno-stage1
  -freference-trace -fno-reference-trace
  -fsingle-threaded -fno-single-threaded
  -fbuiltin -fno-builtin
  -ffunction-sections -fno-function-sections
  -fstrip -fno-strip
  -ofmt=:'elf,c,wasm,coff,macho,spirv,plan9,hex,raw'
  -idirafter:@dirs
  -isystem:@dirs
  -I:@dirs
  -D
  --libc
  -cflags:@hold
)

opts_run_debug=(
  -ftime-report
  -fstack-report
  --verbose-link
  --verbose-cc
  --verbose-air
  --verbose-llvm-ir
  --verbose-cimport
  --verbose-llvm-cpu-features
  --debug-log:@hold
  --debug-compile-errors
  --debug-link-snapshot
)

opts_run_link=(
  -l:@files
  --library:@files
  -needed-l:@files
  --needed-library:@files
  -L:@dirs
  --library-directory:@dirs
  -T:@files
  --script:@files
  --version-script:@files
  --dynamic-linker:@files
  --sysroot:@dirs
  --version:@hold
  --entry:@hold
  -fsoname:@hold
  -fno-soname
  -fLLD -fno-LLD
  -fcompiler-rt -fno-compiler-rt
  -rdynamic
  -rpath:@dirs
  -feach-lib-rpath -fno-each-lib-rpath
  -fallow-shlib-undefined -fno-allow-shlib-undefined
  -fbuild-id
  -fno-build-id
  --eh-frame-hdr
  --emit-relocs
  -z:'nodelete,notext,defs,origin,nocopyreloc,now,lazy,relro,norelro'
  -dynamic
  -static
  -Bsymbolic
  --compress-debug-sections=:'none,zlib'
  --gc-sections --no-gc-sections
  --subsystem:@hold
  --stack:@hold
  --image-base:@hold
  -weak-l:@files
  -weak_library:@files
  -framework:@hold
  -needed_framework:@hold
  -needed_library:@files
  -weak_framework:@hold
  -F:@dirs
  -install_name=
  --entitlements:@files
  -pagezero_size:@hold
  -search_paths_first
  -search_dylibs_first
  -headerpad:@hold
  -headerpad_max_install_names
  -dead_strip
  -dead_strip_dylibs
  --import-memory
  --import-table
  --export-table
  --initial-memory=
  --max-memory=
  --shared-memory
  --global-base=
  --export=
)

subcmd_opts_test=(
  --test-filter:@hold
  --test-name-prefix:@hold
  --test-cmd:@hold
  --test-cmd-bin
  --test-evented-io
  --test-no-exec

  ${opts_run_general[@]}
  ${opts_run_compile[@]}
  ${opts_run_link[@]}
  ${opts_run_debug[@]}
)
subcmd_args_test=@zig_file

subcmd_opts_run=(
  --

  ${opts_run_general[@]}
  ${opts_run_compile[@]}
  ${opts_run_link[@]}
  ${opts_run_debug[@]}
)
subcmd_args_run=@zig_file

subcmd_comp_alias=(
  ['build-exe']=run
  ['build-lib']=run
  ['build-obj']=run
  ['build-translate-c']=run
)

subcmd_opts_ranlib=(
  -h --help
  -v --version
  -D
  -U
)

subcmd_opts_dlltool=(
  -D:@hold
  -d:@files
  -f:@hold
  -k
  -l:@hold
  -m:@hold
  -S:@hold
)
