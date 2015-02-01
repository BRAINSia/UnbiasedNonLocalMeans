include(${CMAKE_CURRENT_LIST_DIR}/Common.cmake)

#-----------------------------------------------------------------------------
# Update CMake module path
#------------------------------------------------------------------------------


################################################################################

find_package(SlicerExecutionModel REQUIRED GenerateCLP)
include(${GenerateCLP_USE_FILE})
include(${SlicerExecutionModel_USE_FILE})
include(${SlicerExecutionModel_CMAKE_DIR}/SEMMacroBuildCLI.cmake)


#-----------------------------------------------------------------------------
find_package(ITK 4.7 REQUIRED)
if(Slicer_BUILD_BRAINSTOOLS)
  set(ITK_NO_IO_FACTORY_REGISTER_MANAGER 1)
endif()
include(${ITK_USE_FILE})
#-----------------------------------------------------------------------------


#-----------------------------------------------------------------------------
enable_testing()
include(CTest)

option(BUILD_CMPB_VERSIONS "Build the exact same source code used for the CMPB paper" OFF)
if( BUILD_CMPB_VERSIONS )
    add_subdirectory( cmpb.source.code )
endif( BUILD_CMPB_VERSIONS )

# For Slicer 4 builds, simply call the standard macro:
if(Slicer_BINARY_DIR) # This variable exits only for Slicer4

    SEMMacroBuildCLI(
       NAME ${PROJECT_NAME}
       LOGO_HEADER ${PROJECT_SOURCE_DIR}/ModuleLogo.h
       TARGET_LIBRARIES ${ITK_LIBRARIES} ModuleDescriptionParser
       LINK_DIRECTORIES ${ModuleDescriptionParser_BINARY_DIR}
       INCLUDE_DIRECTORIES ${SlicerBaseCLI_SOURCE_DIR} ${Slicer_SOURCE_DIR}/Applications/CLI/DiffusionApplications/DiffusionApplicationsCommon
       ${SlicerBaseCLI_BINARY_DIR}
       RUNTIME_OUTPUT_DIRECTORY ${${CMAKE_PROJECT_NAME}_CLI_RUNTIME_OUTPUT_DIRECTORY}
       LIBRARY_OUTPUT_DIRECTORY ${${CMAKE_PROJECT_NAME}_CLI_LIBRARY_OUTPUT_DIRECTORY}
       ARCHIVE_OUTPUT_DIRECTORY ${${CMAKE_PROJECT_NAME}_CLI_ARCHIVE_OUTPUT_DIRECTORY}
       INSTALL_RUNTIME_DESTINATION ${${CMAKE_PROJECT_NAME}_CLI_INSTALL_RUNTIME_DESTINATION}
       INSTALL_LIBRARY_DESTINATION ${${CMAKE_PROJECT_NAME}_CLI_INSTALL_LIBRARY_DESTINATION}
       INSTALL_ARCHIVE_DESTINATION ${${CMAKE_PROJECT_NAME}_CLI_INSTALL_ARCHIVE_DESTINATION}
    )

else(Slicer_BINARY_DIR)
    #set(EXTRA_HEADERS itkNLMFilter.txx LSDerivatives/itkLSDerivatives.txx)
    #set(CLP UnbiasedNonLocalMeans)
    #set ( ${CLP}_SOURCE ${CLP}.cxx )
    #CONFIGURESTANDALONEORSLICERPROPERTIES(${CLP} ${CLP}.xml "${${CLP}_SOURCE}" "" "${EXTRA_HEADERS}")
    #target_link_libraries( ${CLP} ${ITK_LIBRARIES} )
    #INSTALL(TARGETS UnbiasedNonLocalMeans DESTINATION bin)


SEMMacroBuildCLI(
       NAME ${PROJECT_NAME}
       EXECUTABLE_ONLY
       LOGO_HEADER ${PROJECT_SOURCE_DIR}/ModuleLogo.h
       TARGET_LIBRARIES ${ITK_LIBRARIES} ModuleDescriptionParser
       LINK_DIRECTORIES ${ModuleDescriptionParser_BINARY_DIR}
       INCLUDE_DIRECTORIES ${SlicerBaseCLI_SOURCE_DIR} ${Slicer_SOURCE_DIR}/Applications/CLI/DiffusionApplications/DiffusionApplicationsCommon
       RUNTIME_OUTPUT_DIRECTORY ${${CMAKE_PROJECT_NAME}_CLI_RUNTIME_OUTPUT_DIRECTORY}
       LIBRARY_OUTPUT_DIRECTORY ${${CMAKE_PROJECT_NAME}_CLI_LIBRARY_OUTPUT_DIRECTORY}
       ARCHIVE_OUTPUT_DIRECTORY ${${CMAKE_PROJECT_NAME}_CLI_ARCHIVE_OUTPUT_DIRECTORY}
       INSTALL_RUNTIME_DESTINATION ${${CMAKE_PROJECT_NAME}_CLI_INSTALL_RUNTIME_DESTINATION}
       INSTALL_LIBRARY_DESTINATION ${${CMAKE_PROJECT_NAME}_CLI_INSTALL_LIBRARY_DESTINATION}
       INSTALL_ARCHIVE_DESTINATION ${${CMAKE_PROJECT_NAME}_CLI_INSTALL_ARCHIVE_DESTINATION}
)

endif(Slicer_BINARY_DIR)

#-----------------------------------------------------------------------------
# Define list of module names
#-----------------------------------------------------------------------------

if (BUILD_TESTING)
add_subdirectory(TestSuite)
endif (BUILD_TESTING)
