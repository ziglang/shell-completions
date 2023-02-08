# [Usage]
# Put "source _zig.bash" in your bashrc.
#
# [Maintainers]
# ADoyle (adoyle.h@gmail.com)
#
# [Code Style]
# All completion function must named with prefix "_zig_completions_".
# All variables and functions must named with prefix "_zig_comp_".
# All options variables must named with prefix "_zig_comp_opts_".
#
# [Notice]
# Current no completions for zig commands: cc c++ dlltool lib ranlib

_zig_comp_cmds=(
  build init-exe init-lib ast-check build-exe build-lib build-obj fmt run test
  translate-c ar cc c++ dlltool lib ranlib env help libc targets version zen
)

_zig_comp_reply_words() {
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -W "$*" -- "$cur") )
}

_zig_comp_reply_cmds() {
  local IFS=$'\n'
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -W "${_zig_comp_cmds[*]}" -- "$cur") )
}

_zig_comp_reply_files() {
  local IFS=$'\n'
  compopt -o nospace -o filenames
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -A file -- "$cur") )
}

_zig_comp_reply_zig_files() {
  compopt -o nospace -o filenames

  local path
  while read -r path; do
    if [[ $path =~ \.(zig|zir|o|obj|lib|a|so|dll|dylib|tbd|s|S|c|cxx|cc|C|cpp|stub|m|mm|bc|cu)$ ]] \
      || [[ -d $path ]]; then
        COMPREPLY+=( "$path" )
    fi
  done < <(compgen -A file -- "$cur")
}

_zig_comp_reply_dirs() {
  local IFS=$'\n'
  compopt -o nospace -o filenames
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -A directory -- "$cur") )
}

_zig_comp_opts=(-h --help)

_zig_comp_reply_opts() {
  local IFS=$'\n'
  # shellcheck disable=2207
  COMPREPLY=( $(compgen -W "${_zig_comp_opts[*]}" -- "$cur") )
}

_zig_comp_opts_build=(
  -p --prefix
  --prefix-exe-dir
  --prefix-include-dir
  --prefix-lib-dir

  --sysroot
  --search-prefix
  --libc
  --glibc-runtimes

  -h --help
  --color
  --verbose
  --prominent-compile-errors

  -fstage1 -fno-stage1
  -fdarling -fno-darling
  -fqemu -fno-qemu
  -fwine -fno-wine
  -frosetta -fno-rosetta
  -fwasmtime -fno-wasmtime
  -freference-trace -fno-reference-trace

  -Dcpu=
  -Drelease-fast=
  -Drelease-safe=
  -Drelease-small=
  -Dtarget=

  --build-file
  --cache-dir
  --global-cache-dir
  --zig-lib-dir
  --debug-log
  --verbose-link
  --verbose-air
  --verbose-llvm-ir
  --verbose-cimport
  --verbose-cc
  --verbose-llvm-cpu-features
)

_zig_comp_reply_build_steps() {
  # https://ziglearn.org/chapter-3/#build-steps
  COMPREPLY=( install uninstall run test )
}

_zig_completions_build() {
  if [[ $cur =~ ^-D ]]; then
    compopt -o nospace
    local words=( -Dcpu= -Drelease-fast= -Drelease-safe= -Drelease-small= -Dtarget= )
    # shellcheck disable=2207
    COMPREPLY=( $(compgen -W "${words[*]}" -- "$cur") )
  elif [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=( $(compgen -W "${_zig_comp_opts_build[*]}" -- "$cur") )
  elif [[ $prev =~ ^- ]]; then
    case "${prev}" in
      --color):
        _zig_comp_reply_words "auto off on"
        ;;

      -p|--prefix|--prefix-lib-dir|--prefix-exe-dir|--prefix-include-dir):
        _zig_comp_reply_dirs
        ;;

      --sysroot|--search-prefix):
        _zig_comp_reply_dirs
        ;;

      --build-file|--libc|--glibc-runtimes):
        _zig_comp_reply_files
        ;;

      --cache-dir|--global-cache-dir|--zig-lib-dir):
        _zig_comp_reply_dirs
        ;;

      -freference-trace):
        # no prompts. wait user input
        ;;

      --debug-log):
        # no prompts. wait user input
        ;;

      -D*):
        # no prompts. wait user input
        ;;

      *)
        _zig_comp_reply_build_steps
        ;;
    esac
  else
    _zig_comp_reply_build_steps
  fi
}

_zig_comp_opts_run_general=(
  -h --help
  --watch
  --color
  -femit-bin -fno-emit-bin
  -femit-asm -fno-emit-asm
  -femit-llvm-ir -fno-emit-llvm-ir
  -femit-llvm-bc -fno-emit-llvm-bc
  -femit-h -fno-emit-h
  -femit-docs -fno-emit-docs
  -femit-analysis -fno-emit-analysis
  -femit-implib -fno-emit-implib
  --show-builtin
  --cache-dir
  --global-cache-dir
  --zig-lib-dir
  --enable-cache
)

_zig_comp_opts_run_compile=(
  -target
  -mcpu
  -mcmodel=
  -mred-zone -mno-red-zone
  -fomit-frame-pointer -fno-omit-frame-pointer
  -mexec-model=
  --name
  -O
  --pkg-begin
  --pkg-end
  --main-pkg-path
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
  -ofmt=
  -idirafter
  -isystem
  -I
  -D
  --libc
  -cflags
)

_zig_comp_opts_run_link=(
  -l --library
  -needed-l --needed-library
  -L --library-directory
  -T --script
  --version-script
  --dynamic-linker
  --sysroot
  --version
  --entry
  -fsoname
  -fno-soname
  -fLLD -fno-LLD
  -fcompiler-rt -fno-compiler-rt
  -rdynamic
  -rpath
  -feach-lib-rpath -fno-each-lib-rpath
  -fallow-shlib-undefined -fno-allow-shlib-undefined
  -fbuild-id
  -fno-build-id
  --eh-frame-hdr
  --emit-relocs
  -z
  -dynamic
  -static
  -Bsymbolic
  --compress-debug-sections=
  --gc-sections --no-gc-sections
  --subsystem
  --stack
  --image-base
  -weak-l -weak_library
  -framework
  -needed_framework
  -needed_library
  -weak_framework
  -F
  -install_name=
  --entitlements
  -pagezero_size
  -search_paths_first
  -search_dylibs_first
  -headerpad
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

_zig_comp_opts_run_debug=(
  -ftime-report
  -fstack-report
  --verbose-link
  --verbose-cc
  --verbose-air
  --verbose-llvm-ir
  --verbose-cimport
  --verbose-llvm-cpu-features
  --debug-log
  --debug-compile-errors
  --debug-link-snapshot
)

# shellcheck disable=2120
_zig_completions__run_general() {
  case "${prev}" in
    # ---[ General Options ---
    --color):
      _zig_comp_reply_words "auto off on"
      ;;

    -femit-bin|-femit-asm|-femit-llvm-ir|-femit-llvm-bc|-femit-h|-femit-analysis|-femit-implib):
      _zig_comp_reply_files
      ;;

    -femit-docs):
      _zig_comp_reply_dirs
      ;;

    --cache-dir|--global-cache-dir|--zig-lib-dir):
      _zig_comp_reply_dirs
      ;;
    # --- General Options ]---

    # ---[ Compile Options ---
    -target|-mcpu|-mexec-model=|--name|-freference-trace|-cflags|--pkg-begin):
      # no prompts. wait user input
      ;;

    -mcmodel=):
      _zig_comp_reply_words "default tiny small kernel medium large"
      ;;

    --main-pkg-path|-idirafter|-isystem|-I):
      _zig_comp_reply_dirs
      ;;

    -ofmt=):
      _zig_comp_reply_words "elf c wasm coff macho spirv plan9 hex raw"
      ;;

    -O):
      _zig_comp_reply_words "Debug ReleaseFast ReleaseSafe ReleaseSmall"
      ;;

    # --- Compile Options ]---

    # ---[ Link Options ---
    --version|--entry|-fsoname|--subsystem|--stack|-install_name=):
      # no prompts. wait user input
      ;;

    -l|--library|-needed-l|--needed-library|-T|--script|--version-script|--dynamic-linker):
      _zig_comp_reply_files
      ;;

    -weak-l|-weak_library|-needed_library|--entitlements):
      _zig_comp_reply_files
      ;;

    -L|--library-directory|--sysroot|-rpath|-F):
      _zig_comp_reply_dirs
      ;;


    -framework|-needed_framework|-weak_framework):
      # no prompts. wait user input
      ;;

    --image-base|-pagezero_size|-headerpad|--initial-memory=|--max-memory=|--global-base=|--export=):
      # no prompts. wait user input
      ;;

    -z):
      _zig_comp_reply_words "nodelete notext defs origin nocopyreloc now lazy relro norelro"
      ;;

    --compress-debug-sections=):
      _zig_comp_reply_words "none zlib"
      ;;
    # --- Link Options ]---

    # ---[ Debug Options ---
    --debug-log):
      # no prompts. wait user input
      ;;
    # --- Debug Options ]---

    *)
      if (( $# > 0 )); then
        "$1"
      else
        _zig_comp_reply_zig_files
      fi
      ;;
  esac
}

_zig_completions_run() {
  if [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=(
      $(compgen -W "--" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_general[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_compile[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_link[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_debug[*]}" -- "$cur")
    )
  elif [[ $prev =~ ^- ]]; then
    _zig_completions__run_general
  else
    _zig_comp_reply_zig_files
  fi
}

_zig_completions_build-exe() { _zig_completions_run; }
_zig_completions_build-lib() { _zig_completions_run; }
_zig_completions_build-obj() { _zig_completions_run; }
_zig_completions_build-translate-c() { _zig_completions_run; }

_zig_comp_opts_test=(
  --test-filter
  --test-name-prefix
  --test-cmd
  --test-cmd-bin
  --test-evented-io
  --test-no-exec
)

_zig_completions__test() {
  case "${prev}" in
    --test-filter|--test-name-prefix|--test-cmd):
      # no prompts. wait user input
      ;;

    *)
      _zig_comp_reply_zig_files
      ;;
  esac
}

_zig_completions_test() {
  if [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=(
      $(compgen -W "${_zig_comp_opts_run_general[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_compile[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_link[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_run_debug[*]}" -- "$cur")
      $(compgen -W "${_zig_comp_opts_test[*]}" -- "$cur")
    )
  elif [[ $prev =~ ^- ]]; then
    _zig_completions__run_general _zig_completions__test
  else
    _zig_comp_reply_zig_files
  fi
}

_zig_comp_opts_fmt=(
  -h --help
  --color
  --stdin
  --check
  --ast-check
  --exclude
)

_zig_completions_fmt() {
  if [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=( $(compgen -W "${_zig_comp_opts_fmt[*]}" -- "$cur") )
  elif [[ $prev =~ ^- ]]; then
    case "${prev}" in
      --color):
        _zig_comp_reply_words "auto off on"
        ;;

      --exclude):
        _zig_comp_reply_zig_files
        ;;

      *):
        _zig_comp_reply_zig_files
        ;;
    esac
  else
    _zig_comp_reply_zig_files
  fi
}

_zig_comp_opts_ast_check=(
  -h --help
  --color
  -t
)

_zig_completions_ast-check() {
  if [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=( $(compgen -W "${_zig_comp_opts_ast_check[*]}" -- "$cur") )
  elif [[ $prev =~ ^- ]]; then
    case "${prev}" in
      --color):
        _zig_comp_reply_words "auto off on"
        ;;

      *):
        _zig_comp_reply_zig_files
        ;;
    esac
  else
    _zig_comp_reply_zig_files
  fi
}

_zig_comp_opts_ar=(
  --format
  --plugin=
  -h --help
  --output
  --rsp-quoting
  --thin
  --version
  -X32
  -X64
  -X32_64
  -X
  @
)

_zig_completions_ar() {
  if [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=( $(compgen -W "${_zig_comp_opts_ar[*]}" -- "$cur") )
  elif [[ $prev =~ ^- ]]; then
    case "${prev}" in
      --format):
        _zig_comp_reply_words "default gnu darwin bsd bigarchive"
        ;;

      --plugin=|-X):
        # no prompts. wait user input
        ;;

      --rsp-quoting):
        _zig_comp_reply_words "posix windows"
        ;;

      @):
        _zig_comp_reply_files
        ;;

      *):
        _zig_comp_reply_zig_files
        ;;
    esac
  else
    _zig_comp_reply_zig_files
  fi
}

_zig_comp_opts_libc=(
  -h --help
  -target
)

_zig_completions_libc() {
  if [[ $cur =~ ^- ]]; then
    # shellcheck disable=2207
    COMPREPLY=( $(compgen -W "${_zig_comp_opts_libc[*]}" -- "$cur") )
  elif [[ $prev =~ ^- ]]; then
    case "${prev}" in
      -target):
        # no prompts. wait user input
        ;;

      *):
        _zig_comp_reply_zig_files
        ;;
    esac
  else
    _zig_comp_reply_zig_files
  fi
}

_zig_completions() {
  COMPREPLY=()
  local cur=${COMP_WORDS[COMP_CWORD]}
  local prev=${COMP_WORDS[COMP_CWORD-1]}

  if (( COMP_CWORD > 1 )); then
    local cmd=${COMP_WORDS[1]}
    if type "_zig_completions_$cmd" &>/dev/null; then
      "_zig_completions_$cmd"
    else
      _zig_comp_reply_words "--help"
    fi
    return 0
  fi

  if [[ $cur =~ ^- ]]; then
    _zig_comp_reply_opts
  elif [[ $prev =~ ^- ]]; then
    case "${prev}" in
      -)
        # No completions.
        ;;

      -t)
        # No completions. User must input argument.
        ;;

      -c|--cmd)
        # No completions. User must input argument.
        ;;

      *)
        _zig_comp_reply_files
        ;;
    esac
  elif [[ $prev =~ ^+ ]]; then
    case "${prev}" in
      +|+/)
        ;;

      *)
        _zig_comp_reply_files
        ;;
    esac
  else
    _zig_comp_reply_cmds
  fi
}

complete -F _zig_completions -o bashdefault zig
