using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace GostReferences.Model
{
    public class LiteratureData
    {
        [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]
        public List<LiteratureSample> LiteratureSamples { get; set; }
    }
}
