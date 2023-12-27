#!/run/current-system/sw/bin/nu
# Nu build script for my NixOS configuration

def main [] {
    # Check if elevated privileges
    if (not ($env.USER | is-admin)) {
        print "ERROR: Please run this script with elevated privileges!"
        exit 1
    }

    let files = [
        configuration.nix
        home.nix
        packages.nix
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

    print "Getting the ezkea cachix for the anime game..."
    run-external "sudo" ["nix-shell" "-p" "cachix" "--run" "cachix use ezkea"]

    # Run nixos-rebuild switch
    print "Running nixos-rebuild switch..."
    run-external "sudo" ["nixos-rebuild" "switch" "--upgrade"]
    print "nixos-rebuild switch done!"
    print "Exiting..."
    exit 0
}