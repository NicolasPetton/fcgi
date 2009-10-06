Eval [
    PackageBuilder new
	name: 'FCGI';
	namespace: 'FCGI';
	prereq: 'Sockets';
	
	filein: 'Records/FCGIRecord.st';
	filein: 'Records/FCGIHeader.st';
	filein: 'Records/FCGIParamRecord.st';
	filein: 'Records/FCGIDefaultRecord.st';
	filein: 'Records/FCGIEndRequestRecord.st';
	filein: 'Records/FCGIBeginRequestRecord.st';
	filein: 'Records/FCGIUnknownTypeRecord.st';
	filein: 'Records/Extensions.st';

	filein: 'Protocol/FCGIVersion1.st';
	filein: 'Protocol/FCGIProtocolVersion1.st';

	filein: 'Server/FCGIServer.st';


	buildXml
]
