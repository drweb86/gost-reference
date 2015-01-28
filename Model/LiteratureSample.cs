using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace GostReferences.Model
{
    [DebuggerDisplay("Title = {Title}, IsIndependent = {IsIndependent}")]
    public class LiteratureSample
    {
        [DebuggerBrowsable(DebuggerBrowsableState.Never)]
        public bool IsIndependent { get; set; }

        [DebuggerBrowsable(DebuggerBrowsableState.Never)]
        public string Title { get; set; }

        [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]
        public List<string> Samples { get; set; }
    }
}
