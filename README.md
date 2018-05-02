# OD-dl_tools

This tool is built to work like "wget --mirror".
It is tested on ubuntu 16.04, but should work on any *nix based system.

## Getting started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
To run this, you will need rclone, GNU parallel and axel.

#### [rclone](https://github.com/ncw/rclone)
```
brew install rclone
```
#### [GNU parallel](https://www.gnu.org/software/parallel/)
```
sudo apt-get install parallel
or
brew install parallel
```

#### [axel](https://github.com/axel-download-accelerator/axel)
```
brew install axel
```
## Installing
### Download the script.

### Make it executable
```
chmod +x OD-dl.sh
```
## Usage
```
./OD-dl.sh url project_folder
```

### Example
What to do:
```
./OD-dl.sh https://the-eye.eu/public/ripreddit ripreddit
```
What not to do:
```
./OD-dl.sh https://the-eye.eu/public/ripreddit/ ripreddit
```
* the url cannot have a trailing slash. The script will not work.

### Output
Files will be downloaded 4x at a time with axel to the local folder you chose.

output would look like
```
$HOME/files/ripreddit/
- folder/
  - file
  - file
- folder2
  - file
  - file
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
