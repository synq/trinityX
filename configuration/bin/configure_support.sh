
# Support functions
# Those do not belong in the common_functions.sh file as they are used only by
# the installer code.


#---------------------------------------

# Directory binding functions
# Bind mounts are used to configure the images. Through bind mount we give
# access to directories that would otherwise be available over NFS, as well as 

# Bind an arbitrary number of mounts under a common root dir

# Syntax: bind_mounts root_dir dir1 [dir2 ...]

function bind_mounts {

    if (( $# < 2 )) ; then
        echo_warn 'bind_mounts: not enough arguments, no mount done.'
        return 1
    fi

    root_dir="$1"
    shift

    for dir in "$@" ; do
        mkdir -p "${root_dir}/${dir}"
        mount --bind "$dir" "${root_dir}/${dir}"
    done
}


# Unbind mounts

#  !!! WARNING !!!
# They must be unbound in reverse order of binding, or interesting times will
# ensue! Why? Two words: recursive bind.

# Syntax: unbind_mounts root_dir dir1 .. dirN
# It will unbind in the order dirN .. dir1

function unbind_mounts {

    if (( $# < 2 )) ; then
        echo_warn 'unbind_mounts: not enough arguments, no umount done.'
        return 1
    fi

    root_dir="$1"
    shift

    for i in $(seq $# -1 1) ; do
        umount "${root_dir}/${@:$i:1}"
    done
}


#---------------------------------------


