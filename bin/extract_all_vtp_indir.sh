#!/bin/bash

if [ ! -f "$1" -o ! -d "$2" ]
then
	echo "Usage: $0 <geom file> <dir>"
	exit
fi

MESHDIR=$2
VOLGEOM=$1
PARALLEL=""
T=.commands
if [ "$PARALLEL" == "YES" ]
then
	T=.commands
	rm -f $T
fi

for i in $MESHDIR/*.vtp
do
	B=`basename $i`
	
#	CMD="/opt/MCRIBS/bin/VTPExtractAll -v --surf-volgeom=$VOLGEOM $MESHDIR/$B"
#	if [ "$PARALLEL" == "YES" ]
#	then
#		echo $CMD >> $T
#	else
#		$CMD
#	fi
        /opt/MCRIBS/VTK/VTK-install/bin/vtkpython /opt/MCRIBS/bin/VTPExtractAll -v --surf-volgeom=$VOLGEOM $MESHDIR/$B
        mris_convert --to-scanner $MESHDIR/${B::-4}_tkr.surf $MESHDIR/${B::-4}_tkr.surf.gii

        sed '0,/<Name><!\[CDATA\[VolGeomWidth\]\]><\/Name>/s|<Name><!\[CDATA\[VolGeomWidth\]\]></Name>|<Name><![CDATA[GeometricType]]></Name>\n<Value><![CDATA[Anatomical]]></Value>\n</MD>\n<MD>\n<Name><![CDATA[VolGeomWidth]]></Name>|' $MESHDIR/${B::-4}_tkr.surf.gii > $MESHDIR/${B::-4}_tkr_fixxml.surf.gii

        
        
done

#if [ "$PARALLEL" == "YES" ]
#then
#	parallel -j+0 --ungroup < $T
#	rm -f $T
#fi
