cmake_minimum_required(VERSION 2.8)
project( UnbiasedNonLocalMeans )

# 
# --------------------------------------------------------------------------
# Special build configs (to handle linking on windows)
#CONFIGURE_FILE(
#  vtkRealignConfigure.h.in
#  Applications/CLI/Realign/vtkRealignConfigure.h
#)


################################################################################
set(STANDALONE_CMAKE_HELPER_DIR ${CMAKE_CURRENT_SOURCE_DIR}/BuildScripts)
include(${STANDALONE_CMAKE_HELPER_DIR}/CMakeBuildMacros.cmake)
include(${STANDALONE_CMAKE_HELPER_DIR}/PreventInSourceBuilds.cmake)
include(${STANDALONE_CMAKE_HELPER_DIR}/CMakeSTANDALONE3BuildMacros.cmake)

###
SETIFEMPTY(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
SETIFEMPTY(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
SETIFEMPTY(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
SETIFEMPTY(CMAKE_BUNDLE_OUTPUT_DIRECTORY  ${CMAKE_CURRENT_BINARY_DIR})
link_directories(${CMAKE_LIBRARY_OUTPUT_DIRECTORY} ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY})
###
CHECKIFSLICER3BUILD()  ## Call the convenience macro

if (Slicer_SOURCE_DIR)
    SET_SOURCE_FILES_PROPERTIES(${CLP}.cxx COMPILE_FLAGS -DTHISISASLICERBUILD=1)
else( Slicer_SOURCE_DIR )
    ADD_SUBDIRECTORY(SlicerExecutionModel)
    OPTION(BUILD_TESTING "Build tests for this program" ON)
    if( BUILD_TESTING )
        ENABLE_TESTING()
    endif( BUILD_TESTING )
endif (Slicer_SOURCE_DIR)
################################################################################

if(NOT ITK_FOUND)
    find_package(ITK REQUIRED)
    include(${ITK_USE_FILE})
endif(NOT ITK_FOUND)


set(CLP UnbiasedNonLocalMeans)
set ( ${CLP}_SOURCE ${CLP}.cxx )
CONFIGURESTANDALONEORSLICERPROPERTIES(${CLP} ${CLP}.xml "${${CLP}_SOURCE}" "")
target_link_libraries( ${CLP} ITKIO ITKAlgorithms)

INSTALL(TARGETS UnbiasedNonLocalMeans DESTINATION bin)

if (BUILD_TESTING)
  add_executable(${CLP}_Compare ${CLP}_Compare.cxx)
  target_link_libraries(${CLP}_Compare
    ITKIO
    ITKNumerics
    ITKStatistics
  )
  
  set(TEST_DATA_DIR ${PROJECT_SOURCE_DIR}/TestData)
  if (Slicer_SOURCE_DIR)
    set(OUTPUT_DIR ${Slicer3_BINARY_DIR}/Testing)
    set(Slicer3_EXE ${Slicer3_BINARY_DIR}/Slicer3)
    SET(RUNEXEC
        ${Slicer3_EXE}
        --launch
        ${CLP}
    )
    SET(COMPEXEC
        ${Slicer3_EXE}
        --launch
        ${CLP}_Compare
    )
  else( Slicer_SOURCE_DIR )
    set(OUTPUT_DIR ${CMAKE_BINARY_DIR}/Testing)
    SET( RUNEXEC ${CMAKE_BINARY_DIR}/${CLP} )
    SET( COMPEXEC ${CMAKE_BINARY_DIR}/${CLP}_Compare )
  endif (Slicer_SOURCE_DIR)

  # This runs the module with testing parameters:
  add_test(${PROJECT_NAME}_SampleTest
    ${RUNEXEC}
    --sigma 65
    --rs 3,3,3
    --rc 1,1,1
    --hp 1.0
    --ps 2.0
    ${TEST_DATA_DIR}/t2crop.nii.gz
    ${OUTPUT_DIR}/t2filteredSample.nii.gz
  )

  # This runs a program that checks the output and compares to the one expected:
  add_test(${PROJECT_NAME}_SampleCompare
    ${COMPEXEC}
    ${OUTPUT_DIR}/t2filteredSample.nii.gz
    ${TEST_DATA_DIR}/t2filtered.nii.gz
  )

endif (BUILD_TESTING)
