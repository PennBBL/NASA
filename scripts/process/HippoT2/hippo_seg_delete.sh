#!/bin/bash

### This script downloads the hippocampal subfield segmentation for the NASA subjects
### 
### Ellyn Butler
### October 22, 2018


# max 146
#for i in `seq 1 146`; do
i=145
ticket_id=$((1285))
#ticket_id=$((${i} + 1169)) # changes each run, potentially

# --- Delete job ---
/data/joy/BBL/applications/itksnap-3.8.0-beta/bin/itksnap-wt -dss-tickets-delete ${ticket_id}
	
#done
