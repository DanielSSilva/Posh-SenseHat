using System;
using System.Collections.Generic;
using System.Drawing;
using System.Management.Automation;  // PowerShell namespace.
using System.Threading;
using LedMatrix.Helpers;

namespace LedMatrix.CmdLets
{
	
	[Cmdlet(VerbsCommon.Set, "MatrixWithSingleColor")]
	public class MatrixWithSingleColor : Cmdlet
	{
		[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
		public byte Red {get; set;}
		[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
		public byte Green {get; set;}
		[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 2)]
		public byte Blue {get; set;}

		protected override void	ProcessRecord()
		{
		
			Int16 pixel = (Int16) ( (Red << 11 ) | (Green << 5 ) | Blue);
			Console.WriteLine($"Pixel value = {pixel}");
			Int16[] pixelList = new Int16[64];
			for(int i = 0 ; i < pixelList.Length ; ++i)
			{
				pixelList[i] = pixel;
			}
            Helper.WriteToFile(pixelList.ConvertToByteArray());
		}
	}
}
