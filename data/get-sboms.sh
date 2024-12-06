#!/bin/bash

# Check if the target output folder is provided as an argument
if [ "$#" -lt 2 ]; then
  echo "Usage: $0 /path/to/output/directory --tools TOOL1,TOOL2,..."
  echo "Tools options: trivy, cdxgen, syft, ort, all"
  exit 1
fi

# Get the target output directory from the command-line argument
output_base_dir="$1"

# Get the list of tools to run from the argument
tools_flag="$3"
echo $tools_flag
IFS=',' read -r -a tools <<< "$tools_flag"  # Split the tools by comma

# Set the parent directory containing the folders (modify this as needed)
parent_dir="../projects"

# Iterate over each item in the parent directory
for item in "$parent_dir"/*; do
  # Check if the item is a directory
  if [ -d "$item" ]; then
    # Get the folder name without the full path
    folder_name=$(basename "$item")

    # Define the target output folder for the current folder
    target_folder="$output_base_dir"
    mkdir -p "$target_folder/cdxgen" "$target_folder/trivy" "$target_folder/syft" "$target_folder/ort"

    # Create the target folder if it doesn't exist
    mkdir -p "$target_folder"

    # Execute your commands here
    echo "Processing folder: $folder_name"

    # Run cdxgen if included in the tools list
    if [[ " ${tools[@]} " =~ " cdxgen " ]] || [[ " ${tools[@]} " =~ " all " ]]; then
      echo "Running cdxgen for $folder_name"
      docker run --rm -v /tmp:/tmp -v $(pwd)/..:/app:rw -t ghcr.io/cyclonedx/cdxgen -r /app/projects/$folder_name -o /app/data/$target_folder/cdxgen/$folder_name-result.json -t python
    fi

    # Run trivy if included in the tools list
    if [[ " ${tools[@]} " =~ " trivy " ]] || [[ " ${tools[@]} " =~ " all " ]]; then
      echo "Running trivy for $folder_name"
      trivy fs --format cyclonedx --include-dev-deps --list-all-pkgs --output $target_folder/trivy/$folder_name-result.json ../projects/$folder_name
    fi

    # Run syft if included in the tools list
    if [[ " ${tools[@]} " =~ " syft " ]] || [[ " ${tools[@]} " =~ " all " ]]; then
      echo "Running syft for $folder_name"
      syft scan ../projects/${folder_name} -o cyclonedx-json > $target_folder/syft/${folder_name}-result.json
    fi

    # Run ort if included in the tools list
    if [[ " ${tools[@]} " =~ "ort" ]] || [[ " ${tools[@]} " =~ "all" ]]; then
      echo "Running ort for $folder_name"
      # Run the Docker command for ort analyze
      docker run --rm -v /tmp:/tmp -v $(pwd)/..:/app -t ort analyze -i /app/projects/$folder_name -o /app/data/$target_folder/ort -f JSON

      # Run the Docker command for ort report
      docker run -v /tmp:/tmp -v $(pwd)/..:/app -t ort report -i /app/data/$target_folder/ort/analyzer-result.json -o /app/data/$target_folder/ort -f CycloneDx
      # docker run --rm -v /tmp:/tmp -v $(pwd)/..:/app -t ort bash -c "ort analyze -i /app/projects/$folder_name -o /app/$target_folder/ort -f JSON && ort report -i /app/$target_folder/ort/analyzer-result.json -o /app/$target_folder/ort -f CycloneDx"
    
      # Remove the ort analyzer JSON
      rm $target_folder/ort/analyzer-result.json 

      # Move the ort CycloneDX XML file to the output folder
      mv $target_folder/ort/bom.cyclonedx.xml $target_folder/ort/$folder_name.cyclonedx.xml
    fi

   

    # Optionally, print a success message
    echo "Completed processing for $folder_name"
  fi
done
