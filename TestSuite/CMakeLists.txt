
add_executable(${CLP}_Compare ${CLP}_Compare.cxx)
target_link_libraries(${CLP}_Compare ${ITK_LIBRARIES} )

set(TEST_DATA_DIR ${PROJECT_SOURCE_DIR}/TestData)
set(OUTPUT_DIR    ${CMAKE_CURRENT_BINARY_DIR} )
set(LAUNCH_EXE "")

if (Slicer_SOURCE_DIR AND Slicer_BINARY_DIR)
  # And this is for Slicer4. It requires calling the CLI with the full path
  set(Slicer_EXE ${Slicer_BINARY_DIR}/Slicer)
  set(LAUNCH_EXE "${Slicer_EXE} --launch ")
endif ()

# This runs the module with testing parameters:
add_test(NAME ${PROJECT_NAME}_SampleTest
  COMMAND ${LAUNCH_EXE} $<TARGET_FILE:${CLP}>
  --sigma 65
  --rs 3,3,3
  --rc 1,1,1
  --hp 1.0
  --ps 2.0
  ${TEST_DATA_DIR}/t2crop.nii.gz
  ${OUTPUT_DIR}/t2filteredSample.nii.gz
)

# This runs a program that checks the output and compares to the one expected:
add_test(NAME ${PROJECT_NAME}_SampleCompare
   COMMAND ${LAUNCH_EXE} $<TARGET_FILE:${CLP}_Compare>
  ${OUTPUT_DIR}/t2filteredSample.nii.gz
  ${TEST_DATA_DIR}/t2filtered.nii.gz
)
set_property(TEST ${PROJECT_NAME}_SampleCompare APPEND PROPERTY DEPENDS ${PROJECT_NAME}_SampleTest)
