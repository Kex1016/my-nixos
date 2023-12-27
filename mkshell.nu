#!/run/current-system/sw/bin/nu
# Nu build script for my nu shell config

def main [] {
    # Check if elevated privileges
    if (not ($env.USER | is-admin)) {
        print "ERROR: Please run this script with elevated privileges!"
        exit 1
    }

    let files = [
        shell.nu
    ]

    # Loop through files and check if they exist in /etc/nixos
    print "Checking if files exist..."
    let out = $files | each { |file|
        let path = "/etc/nixos/" + $file
        print $"($path | path type)"
        if ($path | path exists) {
            print $"> Path exists: ($path)"
            $"($file)"
        } else {
            print $"ERROR: Path does not exist: ($path)"
            exit 1
        }
    }

    # Remove old files from /etc/nixos
    print "Removing old files..."
    let out = $files | each { |file|
        let path = "/etc/nixos/" + $file
        if ($path | path exists) {
            print $"> Removing ($path)"
            run-external "sudo" ["rm" "-rf" $"\"($path)\""]
            $"($file)"
        }
    }

    # Copy new files to /etc/nixos
    print "Copying new files..."
    let out = $files | each { |file|
        let path = "/etc/nixos/" + $file
        let source = "./config/" + $file
        if ($source | path exists) {
            print $"> Copying ($path)"
            run-external "sudo" ["cp" $"\"($source)\"" $"\"($path)\""]
            $"($file)"
        }
    }
    print "Copying done!\nAffected files:"
    print $out

    print "Done! Please run \"source /etc/nixos/shell.nu\" to apply changes."
    exit 0
}