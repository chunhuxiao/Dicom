BEGIN {
	vr["AE"] = 0;
	vr["AS"] = 0;
	vr["AT"] = 0;
	vr["CS"] = 0;
	vr["DA"] = 0;
	vr["DS"] = 0;
	vr["DT"] = 0;
	vr["FL"] = 0;
	vr["FD"] = 0;
	vr["IS"] = 0;
	vr["LO"] = 0;
	vr["LT"] = 0;
	vr["OB"] = 0;
	vr["OF"] = 0;
	vr["OW"] = 0;
	vr["PN"] = 0;
	vr["SH"] = 0;
	vr["SL"] = 0;
	vr["SQ"] = 0;
	vr["SS"] = 0;
	vr["ST"] = 0;
	vr["TM"] = 0;
	vr["UI"] = 0;
	vr["UL"] = 0;
	vr["UN"] = 0;
	vr["US"] = 0;
	vr["UT"] = 0;

	print "" > "rejected.log";
	
	print "#include \"stdafx.h\"";
	print "#include \"dictionary.h\"\n";
	print "// DO NOT EDIT, this file autogenerated with dicom.awk\n";
	print "entry dictionary [] = {\n";
	
}

{
	if($(NF) != "RET")
	{
		if($1 ~ /\([0-9ABCDEF]+,[0-9ABCDEF]+\)/)
		{
			if($(NF-1) in vr && $(NF-2) != "or")
			{
				vr[$(NF-1)]++;
				description = "";
				for(n = 2; n < (NF-1); n++)
				{
					if(0<length(description))
					{
						description = description " ";
					}
					description = description $(n);
				}
				print "{\"" $1 "\",\t\"" $(NF-1) "\",\t\"" $(NF) "\",\t\"" description "\"},";
			}
			else
			{
				print "bad vr :", $0 >> "rejected.log"
			}
		}
		else
		{
			print "bad tag: ", $0 >> "rejected.log";
		}
	}
	else
	{
		print "retired: ", $0 >> "rejected.log";
	}
}

END {
	print "NULL,\t\t\tNULL,\tNULL,\tNULL\n";
	print "};";
	
	print "" > "counts.log";
	for(text in vr)
	{
		print text " " vr[text] >> "counts.log";
	}
}