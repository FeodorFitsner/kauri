##
##  kauri
##
##  Copyright (C) 2015 Stefano Azzalini <steazzalini>
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program. If not, see <http://www.gnu.org/licenses/>.
##

include(FeatureSummary)

## -- KAURI_DEFINE_TEST_TARGETS --

option(KAURI_DEFINE_TEST_TARGETS "Define unit test targets." OFF)

add_feature_info(
    KAURI_DEFINE_TEST_TARGETS
    KAURI_DEFINE_TEST_TARGETS
    "if set to ON, targets for unit testing such as `test' are defined.")

## -- KAURI_LOG_CMAKE_FEATURE_SUMMARY --

option(KAURI_LOG_CMAKE_FEATURE_SUMMARY "Log a complete cmake features summary." OFF)

add_feature_info(
    KAURI_LOG_CMAKE_FEATURE_SUMMARY
    KAURI_LOG_CMAKE_FEATURE_SUMMARY
    "if set to ON, a log file reporting all the packages, features, etc is written to the path defined in KAURI_LOG_FEATURE_SUMMARY_PATH.")

## -- KAURI_LOG_CMAKE_FEATURE_SUMMARY_PATH --

set(KAURI_LOG_CMAKE_FEATURE_SUMMARY_PATH "${CMAKE_BINARY_DIR}/log/cmake_feature_summary.log"
    CACHE STRING
    "If KAURI_LOG_CMAKE_FEATURE_SUMMARY is enabled, defines where to save the cmake features summary log.")

## -- KAURI_LOG_XML_TARGETS_INFO --

option(KAURI_LOG_XML_TARGETS_INFO "Define if log a XML file containing all the information about the produced targets." OFF)

add_feature_info(
    KAURI_LOG_XML_TARGETS_INFO
    KAURI_LOG_XML_TARGETS_INFO
    "if set to ON, a XML file containing all the informations about the produced targets is stored in the path defined by KAURI_LOG_CMAKE_FEATURE_SUMMARY_PATH. This file contains for each target the soruce files used to build it, the toolchain and it configuration, as well as output location and other informations.")

## -- KAURI_LOG_XML_TARGETS_INFO_PATH --

set(KAURI_LOG_XML_TARGETS_INFO_PATH "${CMAKE_BINARY_DIR}/log/targets.xml"
    CACHE STRING
    "Define where to store the file described in KAURI_LOG_XML_TARGETS_INFO.")

## END ##
