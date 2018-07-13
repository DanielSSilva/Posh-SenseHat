using System;
using System.Collections.Generic;
using System.Drawing;
using System.Management.Automation;  // PowerShell namespace.
using System.Numerics;
using System.Threading;
using LedMatrix.Helpers;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp.Processing.Transforms;

namespace LedMatrix.CmdLets
{
	
	[Cmdlet(VerbsCommon.Set, "ImageFromFile")]
	public class ImageFromFile : Cmdlet
	{
		[Parameter(Mandatory = true, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 0)]
		public string PathToImage {get; set;}

		private int _Rotate = 0;

		[Parameter(Mandatory = false, ValueFromPipeline = true, ValueFromPipelineByPropertyName = true, Position = 1)]
		public int Rotate 
		{
			get
			{
				return _Rotate;
			}
			set
			{
				_Rotate = value;
			}
		}
		
		protected override void	ProcessRecord()
		{
			Image<Bgr565> image = Image.Load<Bgr565>(PathToImage);
			image.Rotate(_Rotate);
			if(image.Height != 8 || image.Width != 8)
				throw new Exception("Image must be 8x8");
			
			Int16[] pixelList = new Int16[64];
			int idx = 0; //each iteration increments this value
			for(int columnIdx = 0 ; columnIdx < image.Height ; ++columnIdx)
			{
				for(int rowIdx = 0; rowIdx < image.Width ; ++rowIdx)
				{
					pixelList[idx++] = (Int16)image[rowIdx,columnIdx].PackedValue;
				} 
			}
			Helper.WriteToFile(pixelList.ConvertToByteArray());			
		}
	}
}
