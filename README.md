## OpenCV: Open Source Computer Vision Library

### Resources

* Homepage: <https://opencv.org>
  * Courses: <https://opencv.org/courses>
* Docs: <https://docs.opencv.org/master/>
* Q&A forum: <http://answers.opencv.org>
* Issue tracking: <https://github.com/opencv/opencv/issues>
* Additional OpenCV functionality: <https://github.com/opencv/opencv_contrib> 


### Contributing

Please read the [contribution guidelines](https://github.com/opencv/opencv/wiki/How_to_contribute) before starting work on a pull request.

#### Summary of the guidelines:

* One pull request per issue;
* Choose the right base branch;
* Include tests and documentation;
* Clean up "oops" commits before submitting;
* Follow the [coding style guide](https://github.com/opencv/opencv/wiki/Coding_Style_Guide).


### Installation

- [install opencv4 on ubuntu 18.04](https://learnopencv.com/install-opencv-4-on-ubuntu-18-04/)
- [missing files](https://github.com/opencv/opencv_contrib/issues/1301):
  - curl use proxy: `curl -x http://xxx.xx.xxx.xxx:xxxx`, note must be http
  - ippicv: export https_proxy etc
  - download bebavior is defined in `opencv/cmake/OpenCVDownload.cmake`
  ```cmake
  function(ocv_download)
    ...
    file(DOWNLOAD "${DL_URL}" "${CACHE_CANDIDATE}"
           STATUS status
           LOG __log
           ${OPENCV_DOWNLOAD_PARAMS})
    ...
  endfunction
  ```
  Since cmake use curl to download, for older curl version, upper-case HTTP_PROXY may need...
