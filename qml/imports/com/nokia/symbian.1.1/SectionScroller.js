/****************************************************************************
**
** Copyright (C) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the Qt Components project.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Nokia Corporation and its Subsidiary(-ies) nor
**     the names of its contributors may be used to endorse or promote
**     products derived from this software without specific prior written
**     permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
** $QT_END_LICENSE$
**
****************************************************************************/

.pragma library

// List of sectionscroller lists in application. Contains their
// sections and their sectiondata.
var _listViewList = [];

// Initialize and save the sections and sectiondata variables for the
// list.
function initSectionData(list) {
    if (!list || !list.model) return;

    if(!_listViewList[list])
        _listViewList[list] = new Object();

    _listViewList[list].sectionData = [];
    _listViewList[list].sections = [];
    var current = "";
    var prop = list.section.property;

    for (var i = 0, count = (typeof list.model.count === 'undefined' ? list.model.length : list.model.count); i < count; i++) {
        var item = list.model.get(i);
        if (item[prop] !== current) {
            current = item[prop];
            _listViewList[list].sections.push(current);
            _listViewList[list].sectionData.push({ index: i, header: current });
        }
    }
}

function closestSection(list, pos) {
    var sections = _listViewList[list].sections
    var tmp = (sections.length) * pos;
    var val = Math.ceil(tmp) // TODO: better algorithm
    val = val < 2 ? 1 : val;
    return sections[val-1];
}

function indexOf(list, sectionName) {
    var sectionData = _listViewList[list].sectionData
    var sections = _listViewList[list].sections
    var val =  sectionData[sections.indexOf(sectionName)].index;
    return val === 0 || val > 0 ? val : -1;
}

function removeSectionData(list) {
    delete _listViewList[list];
}
