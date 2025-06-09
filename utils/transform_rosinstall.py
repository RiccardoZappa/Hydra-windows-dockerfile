import sys
import os

def transform_rosinstall(input_file, output_file):
    """
    Transforms a .rosinstall file by replacing 'git@github.com:' with 'https://github.com/'.
    """
    try:
        with open(input_file, 'r') as f_in:
            content = f_in.read()

        transformed_content = content.replace('git@github.com:', 'https://github.com/')

        with open(output_file, 'w') as f_out:
            f_out.write(transformed_content)
        print(f"Successfully transformed '{input_file}' and saved to '{output_file}'.")
    except FileNotFoundError:
        print(f"Error: The file '{input_file}' was not found.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An error occurred: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python transform_rosinstall.py <input_rosinstall_file> <output_rosinstall_file>", file=sys.stderr)
        sys.exit(1)

    input_rosinstall = sys.argv[1]
    output_rosinstall = sys.argv[2]
    transform_rosinstall(input_rosinstall, output_rosinstall)