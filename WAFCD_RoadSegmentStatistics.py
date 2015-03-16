from __future__ import unicode_literals

#-------------------------------------------------------------------------------
# Project: Web-based Analysis of Floating Car Data
# Subproject: Statistical weights for street segments
#-------------------------------------------------------------------------------

import arcpy as ap
import math
import sys, os

'''
@author: Tobias Tresselt (tobias.tresselt@wwu.de)
@organization: Institute for Geoinformatics, WWU Muenster
@version: 0.0.1
@since: Created on 05.03.2015
@parameters: measurements_file, roads_featureclass, output_gdb
'''


#===============================================================================
# Basic Functions
#===============================================================================

# Log message to ArcMap message window
def log(message, severity=0):
	try:
		for line in message.split('\n'):
			if severity == 0:
				ap.AddMessage(line)
			elif severity == 1:
				ap.AddWarning(line)
			elif severity == 2:
				ap.AddError(line)
	except:
		pass


#===============================================================================
# 1) Read script parameters
#===============================================================================

# Read input variables
log('Reading input variables...')

# feature class of road network with OSM IDs
roads_fc = ap.GetParameterAsText(0) # feature class
log('  - roads features       : %s' % roads_fc)

# text file of enviroCar measurements, matched to OSM IDs
measurements_file = ap.GetParameterAsText(1) # .csv file
log('  - measurements file    : %s' % measurements_file)

# output folder
output_folder = ap.GetParameterAsText(2) # folder
log('  - output folder        : %s' % output_folder)

# output GDB name
out_gdb_name = ap.GetParameterAsText(3) # string
log('  - output FGDB          : %s' % out_gdb_name)


#===============================================================================
# Fixed literals
#===============================================================================

OUT_GDB = output_folder + '\\' + out_gdb_name + '.gdb'

ROADS_FEATURECLASS = OUT_GDB + '\\roads_featureclass'

MEASUREMENTS_TABLE_NAME = 'measurements_table'
MEASUREMENTS_TABLE = OUT_GDB + '\\' + MEASUREMENTS_TABLE_NAME

STATISTICS_TABLE = OUT_GDB + '\\statistics_table'
STATISTICS_FIELDS = [['Speed','MEAN'],['Speed','MIN'],['Speed','MAX'],['Speed','STD']]
STAT_RESULT_FIELDS = ['MEAN_Speed', 'MIN_Speed', 'MAX_Speed', 'STD_Speed']
CASE_FIELD = 'OSM_ID'
TIME_FIELD = 'TimeLength'


#===============================================================================
# 2) Data preparation
#===============================================================================

# create output FGDB
log('Creating geodatabase...')
ap.CreateFileGDB_management(output_folder, out_gdb_name)

# import text file to GDB
log('Importing measurements table...')
ap.TableToTable_conversion(measurements_file, OUT_GDB, MEASUREMENTS_TABLE_NAME, "#", '"OSM_ID "OSM_ID" true true false 255 Text 0 0 ,First,#,{0},OSM_ID,-1,-1;time "time" true true false 255 Text 0 0 ,First,#,{0},time,-1,-1;Speed "Speed" true true false 255 Float 0 0 ,First,#,{0},Speed,-1,-1;GPS_Bearing "GPS_Bearing" true true false 255 Float 0 0 ,First,#,{0},GPS.Bearing,-1,-1"'.format(measurements_file), "#")

# import roads feature class to GDB
log('Importing roads feature class...')
ap.CopyFeatures_management (roads_fc, ROADS_FEATURECLASS)

#===============================================================================
# 3) Calculations
#===============================================================================

# calculate summary statistics
log('Calculating statistics...')
ap.Statistics_analysis(MEASUREMENTS_TABLE, STATISTICS_TABLE, STATISTICS_FIELDS, CASE_FIELD)

# join results to road features
log('Joining fields...')
ap.JoinField_management(ROADS_FEATURECLASS, CASE_FIELD, STATISTICS_TABLE, CASE_FIELD, STAT_RESULT_FIELDS)

# add extra fields
log('Adding extra fields...')
ap.AddField_management(ROADS_FEATURECLASS, 'VC_Speed', 'DOUBLE')
ap.AddField_management(ROADS_FEATURECLASS, 'MEAN_' + TIME_FIELD, 'DOUBLE')
ap.AddField_management(ROADS_FEATURECLASS, 'MIN_' + TIME_FIELD, 'DOUBLE')
ap.AddField_management(ROADS_FEATURECLASS, 'MAX_' + TIME_FIELD, 'DOUBLE')

# 
# calculate time fields: SegmentLength / Speed * 3600 / 1000 [conversion from hours to seconds and from metres to kilometres]
log('Calculating time fields...')
ap.CalculateField_management(ROADS_FEATURECLASS, 'VC_Speed', '!STD_Speed! / !MEAN_Speed!', 'PYTHON_9.3')
ap.CalculateField_management(ROADS_FEATURECLASS, 'MEAN_' + TIME_FIELD, '!Shape_Length! / !MEAN_Speed! * 3.6', 'PYTHON_9.3')
ap.CalculateField_management(ROADS_FEATURECLASS, 'MIN_' + TIME_FIELD, '!Shape_Length! / !MIN_Speed! * 3.6', 'PYTHON_9.3')
ap.CalculateField_management(ROADS_FEATURECLASS, 'MAX_' + TIME_FIELD, '!Shape_Length! / !MAX_Speed! * 3.6', 'PYTHON_9.3')